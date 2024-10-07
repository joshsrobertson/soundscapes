import SwiftUI
import AVFoundation
import Combine

struct SoundscapeDetailView: View {
    // Audio Engine and Player Nodes
    @State private var audioEngine = AVAudioEngine()
    @State private var soundscapePlayer = AVAudioPlayerNode()
    
    // Timer Variables
    @State private var timer: Timer?
    @State private var remainingTime: Int = 60 // Default to 60 seconds
    @State private var isPlaying: Bool = false
    
    // Selected Soundscape, Breathing Pattern, and Timer Duration
    var selectedSoundscape: String
    var selectedBreathingPattern: String
    var selectedTime: Int // Time selected in HomeView

    // Breathing pattern support
    @State private var showBreathingPattern = false // Toggle to show breathing pattern
    
    @Environment(\.presentationMode) var presentationMode // For navigating back to HomeView
    
    var body: some View {
        ZStack {
            // Soundscape and Timer UI
            VStack(spacing: 20) {
                // "Playing: Nature" or "Playing: Electronic" text
                Text("Playing: \(selectedSoundscape)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Control Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        stopAudio()
                        presentationMode.wrappedValue.dismiss() // Navigate back to HomeView
                    }) {
                        Text("Stop")
                            .font(.title2)
                            .padding()
                            .frame(width: 200)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                // Show breathing pattern if selected
                if selectedBreathingPattern != "None" && isPlaying {
                    BreathingPatternView(pattern: selectedBreathingPattern, remainingTime: $remainingTime)
                        .padding(.top)
                }

                Spacer()
            }
        }
        .onAppear {
            setupAudioEngine()
            startSoundscapeAndTimer() // Automatically start soundscape on appear
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
        audioEngine.attach(soundscapePlayer)
        audioEngine.connect(soundscapePlayer, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            try audioEngine.start()
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }
    
    func startSoundscapeAndTimer() {
        guard !isPlaying else { return }
        
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("Error starting audio engine: \(error.localizedDescription)")
                return
            }
        }

        // Set the remaining time based on the selected timer duration
        remainingTime = selectedTime * 60
        isPlaying = true
        
        playSoundscape(soundscape: selectedSoundscape)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopAudio()
                self.stopTimer()
            }
        }
        
        if selectedBreathingPattern != "None" {
            showBreathingPattern = true
        }
    }
    
    func playSoundscape(soundscape: String) {
        let soundscapeFileName: String
        switch soundscape {
        case "Nature":
            soundscapeFileName = "Nature"
        case "Electronic":
            soundscapeFileName = "Electronic"
        default:
            soundscapeFileName = "Nature"
        }
        
        guard let soundscapeURL = Bundle.main.url(forResource: soundscapeFileName, withExtension: "wav") else {
            print("Error: Soundscape file not found: \(soundscapeFileName).wav")
            return
        }
        
        do {
            let soundscapeFile = try AVAudioFile(forReading: soundscapeURL)
            soundscapePlayer.scheduleFile(soundscapeFile, at: nil, completionHandler: {
                self.scheduleSoundscapeLoop(soundscapeFile: soundscapeFile)
            })
            soundscapePlayer.play()
        } catch {
            print("Error scheduling soundscape: \(error.localizedDescription)")
        }
    }
    
    func scheduleSoundscapeLoop(soundscapeFile: AVAudioFile) {
        soundscapePlayer.scheduleFile(soundscapeFile, at: nil, completionHandler: {
            self.scheduleSoundscapeLoop(soundscapeFile: soundscapeFile)
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
        showBreathingPattern = false
    }
    
    func stopAudio() {
        soundscapePlayer.stop()
        audioEngine.stop()
        isPlaying = false
    }
}
