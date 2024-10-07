import SwiftUI
import AVFoundation
import AVKit

struct SoundscapeDetailView: View {
    // Audio Engine and Player Nodes
    @State private var audioEngine = AVAudioEngine()
    @State private var soundscapePlayer = AVAudioPlayerNode()
    @State private var breathingPlayer = AVAudioPlayerNode()
    
    // Timer Variables
    @State private var timer: Timer?
    @State private var remainingTime: Int = 60 // Default to 60 seconds
    @State private var isPlaying: Bool = false
    @State private var selectedTime: Double = 1 // User-selected time in minutes (default to 1 minute)
    
    // Selected Soundscape and Breathing Overlay
    var selectedSoundscape: String
    var selectedBreathingOverlay: String?
    
    var body: some View {
        ZStack {
            // Looping Video in the Background
            LoopingVideoPlayer(videoName: "Flight", videoType: "mov")
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2) // Reduced opacity for clearer video. Adjust as needed (0.0 to 1.0)
            
            // Semi-transparent overlay to enhance text readability without obscuring the video
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Playing: \(selectedSoundscape)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Ensure text is readable over the video
                    .padding()
                
                // Timer Slider
                VStack {
                    Text("Set Timer Duration: \(Int(selectedTime)) minutes")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Slider(value: $selectedTime, in: 1...120, step: 1) // 1 to 120 minutes
                        .accentColor(.blue)
                        .padding()
                    
                    Text("Remaining Time: \(formattedTime(remainingTime))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
                
                // Control Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        startSoundscapeAndTimer()
                    }) {
                        Text("Start Soundscape")
                            .font(.title2)
                            .padding()
                            .frame(width: 150)
                            .background(isPlaying ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(isPlaying) // Disable button when playing
                    
                    Button(action: {
                        stopTimer()
                        stopAudio()
                    }) {
                        Text("Stop")
                            .font(.title2)
                            .padding()
                            .frame(width: 150)
                            .background(isPlaying ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(!isPlaying) // Disable button when not playing
                }
            }
        }
        .onAppear {
            setupAudioEngine()
        }
        .onDisappear {
            stopAudio()
        }
    }
    
    // Helper function to format time as "MM:SS"
    func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    // Setup Audio Engine and Attach Nodes
    func setupAudioEngine() {
        // Attach players
        audioEngine.attach(soundscapePlayer)
        audioEngine.attach(breathingPlayer)
        
        // Connect players to the main mixer
        audioEngine.connect(soundscapePlayer, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.connect(breathingPlayer, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            // Configure the audio session
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            
            // Start the audio engine
            try audioEngine.start()
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }

    // Start Soundscape and Timer
    func startSoundscapeAndTimer() {
        guard !isPlaying else { return }
        // Start the timer with the user-selected remaining time in seconds
        remainingTime = Int(selectedTime * 60) // Convert minutes to seconds
        isPlaying = true
        
        // Play soundscape
        playSoundscape(soundscape: selectedSoundscape, breathingOverlay: selectedBreathingOverlay)
        
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopAudio()
                self.stopTimer()
            }
        }
    }
    
    // Play Soundscape and Breathing Overlay
    func playSoundscape(soundscape: String, breathingOverlay: String?) {
        // Determine the correct sound file for the selected soundscape
        let soundscapeFileName: String
        switch soundscape {
        case "Nature":
            soundscapeFileName = "Nature"
        case "Electronic":
            soundscapeFileName = "Electronic"
        default:
            soundscapeFileName = "Nature"
        }
        
        // Load the soundscape audio file
        guard let soundscapeURL = Bundle.main.url(forResource: soundscapeFileName, withExtension: "wav") else {
            print("Soundscape file not found: \(soundscapeFileName).wav")
            return
        }
        
        do {
            let soundscapeFile = try AVAudioFile(forReading: soundscapeURL)
            
            // Schedule the soundscape file for looping playback
            soundscapePlayer.scheduleFile(soundscapeFile, at: nil, completionHandler: {
                // Loop the soundscape by scheduling it again
                self.soundscapePlayer.scheduleFile(soundscapeFile, at: nil, completionHandler: nil)
            })
            soundscapePlayer.play()
            
            // Handle breathing overlay
            if let breathingOverlay = breathingOverlay, breathingOverlay != "None" {
                guard let breathingURL = Bundle.main.url(forResource: breathingOverlay, withExtension: "mp3") else {
                    print("Breathing overlay file not found: \(breathingOverlay).mp3")
                    return
                }
                let breathingFile = try AVAudioFile(forReading: breathingURL)
                breathingPlayer.scheduleFile(breathingFile, at: nil, completionHandler: nil)
                breathingPlayer.play()
            }
        } catch {
            print("Error scheduling soundscape: \(error.localizedDescription)")
        }
    }
    
    // Stop Timer
    func stopTimer() {
        // Invalidate the timer if it's running
        timer?.invalidate()
        timer = nil
        isPlaying = false
    }
    
    // Stop Audio Playback
    func stopAudio() {
        // Stop audio playback and reset nodes
        soundscapePlayer.stop()
        breathingPlayer.stop()
        audioEngine.stop()
        isPlaying = false
        print("Audio stopped")
    }
}
