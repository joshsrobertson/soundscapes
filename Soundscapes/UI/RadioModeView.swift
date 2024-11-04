import SwiftUI
import Kingfisher
import AVFoundation
import Combine

struct RadioModeView: View {
    @StateObject var radioAudioManager = RadioAudioManager()
    @State private var selectedSoundscape: Soundscape? // Store the current soundscape being played
    @State private var sleepTimerSelection = 0 // For dropdown selection
    let sleepTimerOptions = [0, 5, 10, 15, 20, 30, 45, 60] // Sleep timer options in minutes
    @State private var sleepTimerRemaining: Int? = nil // Track remaining sleep timer
    @State private var sleepTimer: Timer? // Keep track of the timer
    @Environment(\.presentationMode) var presentationMode // For navigating back to home

    var body: some View {
        ZStack {
            // Background image using Kingfisher
            if let selectedSoundscape = selectedSoundscape {
                KFImage(URL(string: selectedSoundscape.imageURL))
                    .resizable()
                    .placeholder {
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2)
                        }
                    }
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }

            // Black overlay for better text readability
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Spacer()

                // Soundscape name and description
                if let selectedSoundscape = selectedSoundscape {
                    Text(selectedSoundscape.name)
                        .font(.custom("Baskerville", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Text(selectedSoundscape.description)
                        .font(.custom("Avenir", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // Sleep Timer section
                VStack(spacing: 10) {
                    Text("Sleep Timer")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)

                    // Sleep Timer Dropdown
                    Picker("Set Sleep Timer", selection: $sleepTimerSelection) {
                        ForEach(sleepTimerOptions, id: \.self) { minutes in
                            Text(minutes == 0 ? "Off" : "\(minutes) minutes")
                                .tag(minutes)
                                .font(.custom("Avenir", size: 16))
                                .foregroundColor(.black) // Make text black
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.white) // Add white background
                    .cornerRadius(10) // Add rounded corners for better design
                    .padding(.horizontal, 50) // Adjust horizontal padding to fit the view
                    .onChange(of: sleepTimerSelection) { value in
                        if value > 0 {
                            radioAudioManager.setSleepTimer(minutes: value)
                            sleepTimerRemaining = value * 60 // Convert minutes to seconds
                            startSleepTimerCountdown()
                        } else {
                            stopSleepTimer()
                        }
                    }
                    // Display time remaining for sleep timer
                    if let sleepTimerRemaining = sleepTimerRemaining {
                        Text("Time Remaining: \(formatTime(sleepTimerRemaining))")
                            .font(.custom("Avenir", size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                }

                // Buttons for next soundscape and stopping
                VStack(spacing: 20) {
                    Button(action: {
                        playNextSoundscape()
                    }) {
                        HStack {
                            Image(systemName: "forward.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .frame(width: 150)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }

                    Button(action: {
                        radioAudioManager.stopPlayback()
                    }) {
                        Text("Stop")
                            .font(.custom("Avenir", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(width: 150)
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 75)

                Spacer()
            }
            .onAppear {
                playNextSoundscape() // Start by playing a random soundscape on view load
            }
            .onDisappear {
                stopSleepTimer() // Stop the timer when the view disappears
                radioAudioManager.stopPlayback() // Stop playback when the view disappears
            }
        }
    }

    // Helper function to play the next random soundscape
    private func playNextSoundscape() {
        if let nextSoundscape = radioAudioManager.getNextRandomSoundscape(from: soundscapes) {
            selectedSoundscape = nextSoundscape
            radioAudioManager.playSoundscape(soundscape: nextSoundscape) { [self] in
                playNextSoundscape() // Play the next soundscape on completion
            }
        }
    }

    // Helper function to format time in mm:ss
    func formatTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Helper function to start the countdown for the sleep timer
    private func startSleepTimerCountdown() {
        sleepTimer?.invalidate() // Invalidate the previous timer if any

        sleepTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let sleepTimerRemaining = sleepTimerRemaining {
                if sleepTimerRemaining > 0 {
                    self.sleepTimerRemaining! -= 1
                } else {
                    timer.invalidate() // Stop timer when it reaches 0
                    radioAudioManager.stopPlayback() // Stop audio playback
                    presentationMode.wrappedValue.dismiss() // Return to Home
                }
            }
        }
    }

    // Helper function to stop the sleep timer
    private func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
        sleepTimerRemaining = nil
    }
}

struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(.white.opacity(0.2))
                    .cornerRadius(4)

                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(value), height: geometry.size.height)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

class RadioAudioManager: NSObject, ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var remainingTime: TimeInterval = 0
    @Published var progress: Double = 0.0 // Add progress to be used in ProgressBar
    private var player: AVPlayer?
    private var timer: Timer?
    private var fadeOutTimer: Timer?
    private var soundscapesQueue: [Soundscape] = []

    // Get next random soundscape
    func getNextRandomSoundscape(from soundscapes: [Soundscape]) -> Soundscape? {
        if soundscapesQueue.isEmpty {
            soundscapesQueue = soundscapes.shuffled()
        }
        return soundscapesQueue.removeFirst()
    }

    // Play soundscape from URL with completion handling
    func playSoundscape(soundscape: Soundscape, completion: @escaping () -> Void) {
        guard let url = URL(string: soundscape.audioURL) else {
            print("Invalid URL for soundscape audio")
            return
        }

        // Create an AVPlayer with the soundscape URL
        player = AVPlayer(url: url)
        player?.volume = 1.0 // Set volume

        // Add an observer for when the audio finishes playing
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.stopPlayback()
            completion() // Call completion to play next soundscape
        }

        // Add periodic time observer to update current and remaining time
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            self.remainingTime = (self.player?.currentItem?.duration.seconds ?? 0) - time.seconds
            self.progress = self.currentTime / (self.currentTime + self.remainingTime) // Update progress
        }

        // Start playing
        player?.play()

        // Reset current time and remaining time
        currentTime = 0
        remainingTime = player?.currentItem?.duration.seconds ?? 0

        // Start the timer to update elapsed time
        startTimer()
    }

    // Start timer to track elapsed and remaining time
    private func startTimer() {
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] _ in
            if let player = player {
                currentTime = player.currentTime().seconds
                remainingTime = player.currentItem?.duration.seconds ?? 0 - currentTime
                progress = currentTime / (currentTime + remainingTime) // Update progress
            }
        }
    }

    // Stop playback and invalidate timers
    func stopPlayback() {
        player?.pause()
        timer?.invalidate()
        fadeOutTimer?.invalidate()
        NotificationCenter.default.removeObserver(self) // Remove observer
    }

    // Fade out the sound over time
    func fadeOut(duration: TimeInterval) {
        guard let player = player else { return }

        let fadeSteps: Double = 20
        let fadeInterval = duration / fadeSteps
        let volumeStep = player.volume / Float(fadeSteps)

        fadeOutTimer?.invalidate()
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { [unowned self] timer in
            if player.volume > 0.05 {
                player.volume -= volumeStep
            } else {
                stopPlayback()
                timer.invalidate()
            }
        }
    }

    // Set sleep timer
    func setSleepTimer(minutes: Int) {
        let sleepTime = TimeInterval(minutes * 60)
        Timer.scheduledTimer(withTimeInterval: sleepTime, repeats: false) { [unowned self] _ in
            fadeOut(duration: 60)
        }
    }
}
