import AVFoundation

class SoundscapeAudioManager: ObservableObject {
    var audioEngine = AVAudioEngine()
    var soundscapePlayer = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    var isPlaying = false
    var isSleepMode = false // Flag to track Sleep Mode
    
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

    // Play the selected soundscape with looping functionality
    func playSoundscape(soundscape: String) {
        let soundscapeFileName = soundscape
        
        guard let soundscapeURL = Bundle.main.url(forResource: soundscapeFileName, withExtension: "mp3") else {
            print("Error: Soundscape file not found: \(soundscapeFileName).mp3")
            return
        }

        do {
            audioFile = try AVAudioFile(forReading: soundscapeURL)
            if let audioFile = audioFile {
                scheduleAudioFileLooping(audioFile: audioFile)
                soundscapePlayer.play()
                isPlaying = true
            }
        } catch {
            print("Error scheduling soundscape: \(error.localizedDescription)")
        }
    }

    // Schedule the audio file to loop
    func scheduleAudioFileLooping(audioFile: AVAudioFile) {
        soundscapePlayer.scheduleFile(audioFile, at: nil, completionHandler: {
            // When the sound finishes, schedule the file again to loop it
            self.scheduleAudioFileLooping(audioFile: audioFile)
        })
    }

    // Stop the audio when needed
    func stopAudio() {
        soundscapePlayer.stop()
        audioEngine.stop()
        isPlaying = false
    }

    // Add this function for fading out
    func fadeOut(duration: TimeInterval = 7.0) {
        let steps: Double = 20 // Number of steps in the fade out
        let interval = duration / steps
        let volumeStep = 1.0 / steps
        
        var currentVolume = audioEngine.mainMixerNode.outputVolume
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if currentVolume > 0.05 {
                currentVolume -= Float(volumeStep)
                self.audioEngine.mainMixerNode.outputVolume = currentVolume
            } else {
                timer.invalidate()
                self.stopAudio()
            }
        }
    }

    // Method to handle triggering the fade-out
    func checkForFadeOut(remainingTime: Int) {
        // If Sleep Mode is enabled and 5 minutes (300 seconds) remain, lower the volume to 10%
        if isSleepMode && remainingTime == 300 {
            reduceVolume(to: 0.5)
        }
        if isSleepMode && remainingTime == 250 {
            reduceVolume(to: 0.4)
        }
        if isSleepMode && remainingTime == 200 {
            reduceVolume(to: 0.3)
        }
        if isSleepMode && remainingTime == 150 {
            reduceVolume(to: 0.2)
        }
        // Trigger the fade out when 7 seconds remain
        if remainingTime == 7 {
            fadeOut()
        }
    }

    // Reduce volume to a specified level
    func reduceVolume(to volumeLevel: Float) {
        audioEngine.mainMixerNode.outputVolume = volumeLevel
    }

    // Method to enable or disable Sleep Mode
    func enableSleepMode(_ enabled: Bool) {
        isSleepMode = enabled
    }
}
