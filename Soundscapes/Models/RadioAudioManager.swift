import AVFoundation
import Combine

class RadioAudioManager: NSObject, ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var currentTime: TimeInterval = 0
    private var player: AVAudioPlayer?
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
        if let url = Bundle.main.url(forResource: soundscape.id, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.delegate = self
                player?.play()
                
                remainingTime = player?.duration ?? 0
                currentTime = 0
                
                startTimer()
            } catch {
                print("Error playing soundscape: \(error.localizedDescription)")
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate() // Invalidate previous timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = player.currentTime
            self.remainingTime = player.duration - player.currentTime
        }
    }

    func stopPlayback() {
        player?.stop()
        timer?.invalidate()
    }
}

extension RadioAudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Automatically play the next soundscape when one finishes
        if let nextSoundscape = getNextRandomSoundscape(from: soundscapes) {
            playSoundscape(soundscape: nextSoundscape)
        }
    }
}
