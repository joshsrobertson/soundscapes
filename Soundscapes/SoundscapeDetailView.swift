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

    // Inspirational quotes list
    let quotes = [
        "The wound is the place where the Light enters you. - Rumi",
        "Life is like riding a bicycle. To keep your balance, you must keep moving. - Albert Einstein",
        "What lies behind us and what lies before us are tiny matters compared to what lies within us. - Ralph Waldo Emerson",
        "Be the change that you wish to see in the world. - Mahatma Gandhi",
        "The journey of a thousand miles begins with one step. - Lao Tzu",
        "Go confidently in the direction of your dreams. Live the life you have imagined. - Henry David Thoreau",
        "Everything you can imagine is real. - Pablo Picasso",
        "In the midst of movement and chaos, keep stillness inside of you. - Deepak Chopra",
        "It always seems impossible until it’s done. - Nelson Mandela",
        "You have power over your mind—not outside events. Realize this, and you will find strength. - Marcus Aurelius",
        "Change the way you look at things and the things you look at change. - Wayne Dyer",
        "Realize deeply that the present moment is all you have. - Eckhart Tolle",
        "Smile, breathe, and go slowly. - Thich Nhat Hanh",
        "Faith is taking the first step even when you don't see the whole staircase. - Martin Luther King Jr.",
        "What we think, we become. - Buddha",
        "The unexamined life is not worth living. - Socrates",
        "It does not matter how slowly you go as long as you do not stop. - Confucius",
        "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
       "Your living is determined not so much by what life brings to you as by the attitude you bring to life. - Khalil Gibran",
    ]

    @State private var selectedQuote: String = ""

    // Breathing pattern support
    @State private var showBreathingPattern = false // Toggle to show breathing pattern
    @State private var breathingPhase: String = "Inhale"
    @State private var circleScale: CGFloat = 0.8 // Set to smaller size initially for Inhale
    @State private var cycleStartTime: Int? = nil // Track when the current cycle starts
    
    @Environment(\.presentationMode) var presentationMode // For navigating back to HomeView
    
    // Helper function to get background image name based on selected soundscape
    private func backgroundImageName(for soundscape: String) -> String {
        switch soundscape {
        case "Ocean Waves":
            return "OceanWaves"
        case "Electronic":
            return "Electronic"
        case "Xochimilco":
            return "Xochimilco"
        default:
            return "DefaultBackground"
        }
    }

    // Helper function to select a random quote
    func getRandomQuote() {
        selectedQuote = quotes.randomElement() ?? "Relax, breathe, and take life one step at a time."
    }
    
    var body: some View {
        ZStack {
            // Background Image
            Image(backgroundImageName(for: selectedSoundscape))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all) // Ensure background image fills entire screen

            VStack(spacing: 40) {
                // "Playing: Ocean Waves" or "Playing: Electronic" text
                Text("Playing: \(selectedSoundscape)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.white) // Ensure the text is readable on the image

                Spacer() // To help center the circle vertically

                // If no breathing pattern, display the inspirational quote
                if selectedBreathingPattern == "None" {
                    Text(selectedQuote)
                        .font(.system(size: 19, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .shadow(radius: 10)
                        .background(Color.gray.opacity(0.5))
                        .frame(maxWidth: 300, maxHeight: .infinity, alignment: .center)
                    
                } else {
                    // Breathing Pattern Section (if applicable)
                    ZStack {
                        // Breathing circle that grows and shrinks based on phase
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 10
                            )
                            .frame(width: 250, height: 250)
                            .scaleEffect(circleScale)
                            .animation(.easeInOut(duration: 4), value: circleScale)
                        
                        // Inner Circle
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 150, height: 150)
                            .scaleEffect(circleScale)
                            .animation(.easeInOut(duration: 4), value: circleScale)

                        // Breathing Phase Text (e.g., Inhale, Exhale)
                        Text(breathingPhase)
                            .font(.system(size: 24, weight: .medium, design: .rounded)) // Smaller text
                            .foregroundColor(Color.white)
                    }
                    .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)

                    Spacer()
                }

                // Control Buttons
                Button(action: {
                    stopAudio()
                    presentationMode.wrappedValue.dismiss() // Navigate back to HomeView
                }) {
                    Text("Stop")
                        .font(.body) // Smaller text
                        .padding()
                        .frame(width: 150) // Smaller button
                        .background(Color.gray.opacity(0.8)) // Gray background with 80% opacity
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer() // Additional spacer for bottom padding
            }
        }
        .onAppear {
            setupAudioEngine()
            startSoundscapeAndTimer() // Automatically start soundscape on appear

            // Show an inspirational quote if no breathing pattern is selected
            if selectedBreathingPattern == "None" {
                getRandomQuote()
            }
        }
        .onChange(of: remainingTime) { _ in
            if cycleStartTime == nil {
                cycleStartTime = remainingTime // Record the initial time when the breathing starts
            }
            updateBreathingPhase() // Update breathing phase on each timer change
        }
        .onDisappear {
            stopAudio()
        }
    }

    // Setup Audio Engine and Attach Nodes
    func setupAudioEngine() {
        audioEngine.attach(soundscapePlayer)
        audioEngine.connect(soundscapePlayer, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Set the category to .playback to allow background audio
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            try audioEngine.start()
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }

    // Start Soundscape and Timer
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
        remainingTime = selectedTime * 60 // Convert minutes to seconds
        isPlaying = true
        
        playSoundscape(soundscape: selectedSoundscape)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopAudio()
                self.stopTimer()
                self.presentationMode.wrappedValue.dismiss() // Navigate back to HomeView when the timer expires
            }
        }
        
        if selectedBreathingPattern != "None" {
            showBreathingPattern = true
        }
    }

    // Play soundscape and loop it
    func playSoundscape(soundscape: String) {
        let soundscapeFileName: String
        switch soundscape {
        case "Ocean Waves":
            soundscapeFileName = "OceanWaves"
        case "Electronic":
            soundscapeFileName = "Electronic"
        case "Xochimilco":
            soundscapeFileName = "Xochimilco"
        default:
            soundscapeFileName = "OceanWaves"
        }

        guard let soundscapeURL = Bundle.main.url(forResource: soundscapeFileName, withExtension: "mp3") else {
            print("Error: Soundscape file not found: \(soundscapeFileName).mp3")
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

    // Update breathing phase based on the breathing pattern and timer
    func updateBreathingPhase() {
        guard let cycleStartTime = cycleStartTime else { return }
        let timeElapsed = cycleStartTime - remainingTime
        
        switch selectedBreathingPattern {
        case "Box Breathing":
            let cycleLength = 16
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if phaseTime < 8 {
                breathingPhase = "Hold"
                circleScale = 1.2 // Circle stays the same size during Hold
            } else if phaseTime < 12 {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            } else {
                breathingPhase = "Hold"
                circleScale = 0.8 // Circle stays small during Hold
            }
        case "4-7-8 Breathing":
            let cycleLength = 19
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if phaseTime < 11 {
                breathingPhase = "Hold"
                circleScale = 1.2 // Circle stays the same size during Hold
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            }
        case "In and Out":
            let cycleLength = 8
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            }
        case "Pursed Lip Breathing":
            let cycleLength = 6
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 2 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            }
        default:
            breathingPhase = "Inhale"
            circleScale = 1.2 // Default size for Inhale
        }
    }
}
