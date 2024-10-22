import SwiftUI
import Kingfisher

struct RadioModeView: View {
    @StateObject var radioAudioManager = RadioAudioManager()
    @State private var selectedSoundscape: Soundscape? // Store the current soundscape being played
    @State private var sleepTimerSelection = 0 // For dropdown selection
    let sleepTimerOptions = [0, 5, 10, 15, 20, 30, 45, 60] // Sleep timer options in minutes (added 1 minute)
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

                // Progress bar showing elapsed time
                if selectedSoundscape != nil {
                    ProgressBar(value: radioAudioManager.currentTime / (radioAudioManager.currentTime + radioAudioManager.remainingTime))
                        .frame(height: 8)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 40)
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
            }
            .onChange(of: radioAudioManager.currentTime) { currentTime in
                // If the soundscape ends, play the next one
                if currentTime <= 0 {
                    playNextSoundscape()
                }
            }
        }
    }

    // Helper function to play the next random soundscape
    private func playNextSoundscape() {
        if let nextSoundscape = radioAudioManager.getNextRandomSoundscape(from: soundscapes) {
            selectedSoundscape = nextSoundscape
            radioAudioManager.playSoundscape(soundscape: nextSoundscape)
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
