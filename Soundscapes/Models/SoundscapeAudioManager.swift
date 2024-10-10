import AVFoundation

class SoundscapeAudioManager: ObservableObject {
    var audioEngine = AVAudioEngine()
    var soundscapePlayer = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    
    // To track if Sleep Mode is enabled
    var isSleepMode: Bool = false
    
    // Set up the audio engine
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

    // Play the selected soundscape
    func playSoundscape(soundscape: String) {
        let soundscapeFileName = soundscape
        
        guard let soundscapeURL = Bundle.main.url(forResource: soundscapeFileName, withExtension: "mp3") else {
            print("Error: Soundscape file not found: \(soundscapeFileName).mp3")
            return
        }

        do {
            audioFile = try AVAudioFile(forReading: soundscapeURL)
            if let audioFile = audioFile {
                soundscapePlayer.scheduleFile(audioFile, at: nil, completionHandler: nil)
                soundscapePlayer.play()
            }
        } catch {
            print("Error scheduling soundscape: \(error.localizedDescription)")
        }
    }

    // Stop the audio when needed
    func stopAudio() {
        soundscapePlayer.stop()
        audioEngine.stop()
    }

    // Handle fade-out logic for Sleep Mode
    func checkForFadeOut(remainingTime: Int, fadeOutAfterMinutes: Int = 5) {
        // Convert minutes to seconds for comparison
        let fadeStartThreshold = fadeOutAfterMinutes * 60
        
        if isSleepMode && remainingTime == fadeStartThreshold {
            // Start fading the soundscape over 1 minute
            fadeOut(duration: 60)
        }
    }

    // Fade out the sound over a specified duration
    func fadeOut(duration: TimeInterval) {
        let steps: Double = 20 // Number of steps in the fade-out
        let interval = duration / steps
        let volumeStep = 1.0 / steps
        
        var currentVolume = audioEngine.mainMixerNode.outputVolume
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if currentVolume > 0.5 { // Only fade to half volume
                currentVolume -= Float(volumeStep)
                self.audioEngine.mainMixerNode.outputVolume = currentVolume
            } else {
                timer.invalidate()
            }
        }
    }

    // Enable or disable Sleep Mode
    func setSleepMode(_ isSleepMode: Bool) {
        self.isSleepMode = isSleepMode
    }
}
