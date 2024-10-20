import AVFoundation
import Combine

class RadioAudioManager: NSObject, ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var currentTime: TimeInterval = 0
    private var player: AVPlayer?
    private var timer: Timer?
    private var soundscapesQueue: [Soundscape] = []
    
    func getNextRandomSoundscape(from soundscapes: [Soundscape]) -> Soundscape? {
        // Ensure the soundscapesQueue is randomized and shuffled
        if soundscapesQueue.isEmpty {
            soundscapesQueue = soundscapes.shuffled()
        }
        
        // Play the next soundscape
        return soundscapesQueue.removeFirst()
    }
    
    func playSoundscape(soundscape: Soundscape) {
        // Play sound from the audioURL (S3 URL)
        if let url = URL(string: soundscape.audioURL) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            
            startTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate() // Invalidate previous timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = CMTimeGetSeconds(player.currentTime())
            if let currentItem = player.currentItem {
                self.remainingTime = CMTimeGetSeconds(currentItem.duration) - self.currentTime
            }
        }
    }

    func stopPlayback() {
        player?.pause()
        player = nil
        timer?.invalidate()
    }
}

extension RadioAudioManager: AVPlayerItemOutputPullDelegate {
    // Optionally handle AVPlayer events
}
