import AVFoundation
import Combine

class SoundscapeAudioManager: ObservableObject {
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    @Published var isPlaying = false
    @Published var isSleepMode = false // Flag to track Sleep Mode

    // Play the selected soundscape from the provided S3 URL
    func playSoundscape(from url: String) {
        guard let soundscapeURL = URL(string: url) else {
            print("Error: Invalid URL for soundscape: \(url)")
            return
        }

        // Create a new AVPlayerItem for streaming from the S3 URL
        let playerItem = AVPlayerItem(url: soundscapeURL)
        player = AVQueuePlayer(playerItem: playerItem)

        // Setup the looper to loop the soundscape
        looper = AVPlayerLooper(player: player!, templateItem: playerItem)

        // Observe the playback to detect when the audio is playing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)

        // Play the audio
        player?.play()
        isPlaying = true
    }

    // Called when the audio finishes playing
    @objc private func audioDidFinishPlaying() {
        print("Audio finished playing")
        // No need to stop; the looper handles looping automatically
    }

    // Stop the audio when needed
    func stopAudio() {
        player?.pause()
        player = nil
        looper = nil
        isPlaying = false
    }

    // Add this function for fading out the audio
    func fadeOut(duration: TimeInterval = 7.0) {
        guard let player = player else { return }

        let steps: Double = 20 // Number of steps in the fade out
        let interval = duration / steps
        let volumeStep = player.volume / Float(steps)

        // Reduce the volume progressively
        var currentVolume: Float = player.volume
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if currentVolume > 0.05 {
                currentVolume -= Float(volumeStep)
                player.volume = currentVolume
            } else {
                timer.invalidate()
                self.stopAudio()
            }
        }
    }

    // Method to handle triggering the fade-out based on remaining time
    func checkForFadeOut(remainingTime: Int) {
        guard isSleepMode, let player = player else { return }
        
        // Gradually reduce volume as the timer reaches specific milestones
        if remainingTime == 300 { player.volume = 0.5 }
        if remainingTime == 250 { player.volume = 0.4 }
        if remainingTime == 200 { player.volume = 0.3 }
        if remainingTime == 150 { player.volume = 0.2 }
        
        // Trigger the fade-out when 7 seconds remain
        if remainingTime == 7 {
            fadeOut()
        }
    }

    // Method to enable or disable Sleep Mode
    func enableSleepMode(_ enabled: Bool) {
        isSleepMode = enabled
    }

    // Clean up observer when deallocating the object
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
