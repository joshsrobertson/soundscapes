import AVFoundation

class SoundscapeAudioManager: ObservableObject {
    var audioEngine = AVAudioEngine()
    var soundscapePlayer = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    
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

    func stopAudio() {
        soundscapePlayer.stop()
        audioEngine.stop()
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
        // Trigger the fade out when 7 seconds remain
        if remainingTime == 7 {
            fadeOut()
        }
    }
}
