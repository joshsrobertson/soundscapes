import SwiftUI
import AVFoundation
import Combine

struct SoundscapeDetailView: View {
    // Audio Engine and Player Nodes
    @State private var audioEngine = AVAudioEngine()
    @State private var soundscapePlayer = AVAudioPlayerNode()
    @State private var breathingOverlayPlayer = AVAudioPlayerNode() // For the breathing overlay
    
    // Timer Variables
    @State private var timer: Timer?
    @State private var remainingTime: Int = 60 // Default to 60 seconds
    @State private var isPlaying: Bool = false
    
    // Selected Timer Duration (in minutes)
    @State private var selectedTime: Int = 1 // Default to 1 minute
    let timerOptions = [1, 5, 10, 20, 60] // Options for timer in minutes
    
    // Selected Soundscape, Breathing Pattern, and Overlay
    var selectedSoundscape: String
    var selectedBreathingPattern: String
    var selectedBreathingOverlay: String?
    
    // Breathing pattern support
    @State private var showBreathingPattern = false // Toggle to show breathing pattern
    
    var body: some View {
        ZStack {
            // Soundscape and Timer UI
            VStack(spacing: 20) {
                // Timer Selection (Dropdown Menu)
                VStack {
                    Text("Set Timer Duration")
                        .font(.headline)
                    
                    Picker("Timer Duration", selection: $selectedTime) {
                        ForEach(timerOptions, id: \.self) { time in
                            Text("\(time) minutes").tag(time)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Drop-down menu style for now
                    .padding()
                    
                    Text("Remaining Time: \(formattedTime(remainingTime))")
                        .font(.headline)
                        .padding()
                }
                .padding()
                
                // Control Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        if isPlaying {
                            stopTimer()
                            stopAudio()
                        } else {
                            startSoundscapeAndTimer()
                        }
                    }) {
                        Text(isPlaying ? "Stop" : "Start Soundscape")
                            .font(.title2)
                            .padding()
                            .frame(width: 200)
                            .background(isPlaying ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                // "Playing: Nature" or "Playing: Electronic" text
                Text("Playing: \(selectedSoundscape)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Show breathing pattern if selected
                if selectedBreathingPattern != "None" && isPlaying {
                    BreathingPatternView(pattern: selectedBreathingPattern, remainingTime: $remainingTime, onPhaseChange: playOverlayOnPhaseChange)
                        .padding(.top)
                }

                Spacer()
            }
        }
        .onAppear {
            setupAudioEngine()
            showBreathingPattern = selectedBreathingPattern != "None"
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
        audioEngine.attach(breathingOverlayPlayer) // Attach overlay player
        audioEngine.connect(soundscapePlayer, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.connect(breathingOverlayPlayer, to: audioEngine.mainMixerNode, format: nil) // Connect overlay player
        
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
        
        playSoundscape(soundscape: selectedSoundscape, breathingOverlay: selectedBreathingOverlay)
        
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
    
    func playSoundscape(soundscape: String, breathingOverlay: String?) {
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
            
            // Play breathing overlay if selected
            if let breathingOverlay = breathingOverlay, breathingOverlay != "None" {
                playBreathingOverlay(overlayName: breathingOverlay)
            }
        } catch {
            print("Error scheduling soundscape: \(error.localizedDescription)")
        }
    }
    
    func playBreathingOverlay(overlayName: String) {
        guard let overlayURL = Bundle.main.url(forResource: overlayName, withExtension: "mp3") else {
            print("Error: Breathing overlay file not found: \(overlayName).mp3")
            return
        }
        
        do {
            let overlayFile = try AVAudioFile(forReading: overlayURL)
            breathingOverlayPlayer.scheduleFile(overlayFile, at: nil, completionHandler: nil)
            breathingOverlayPlayer.play()
        } catch {
            print("Error scheduling breathing overlay: \(error.localizedDescription)")
        }
    }
    
    func playOverlayOnPhaseChange(_ phase: String) {
        // Play the overlay sound at the beginning of each breathing phase
        if let overlay = selectedBreathingOverlay, overlay != "None" {
            playBreathingOverlay(overlayName: overlay)
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
        breathingOverlayPlayer.stop() // Stop overlay
        audioEngine.stop()
        isPlaying = false
    }
}
