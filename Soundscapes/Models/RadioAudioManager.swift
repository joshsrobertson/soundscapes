import AVFoundation
import Combine

class RadioAudioManager: NSObject, ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var remainingTime: TimeInterval = 0
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var fadeOutTimer: Timer?
    private var soundscapesQueue: [Soundscape] = []
    
    // Get next random soundscape
    func getNextRandomSoundscape(from soundscapes: [Soundscape]) -> Soundscape? {
        if soundscapesQueue.isEmpty {
            soundscapesQueue = soundscapes.shuffled()
        }
        return soundscapesQueue.removeFirst()
    }
    
    // Play soundscape from URL
    func playSoundscape(soundscape: Soundscape) {
        guard let url = URL(string: soundscape.audioURL) else {
            print("Invalid URL for soundscape audio")
            return
        }

        do {
            let audioData = try Data(contentsOf: url) // Load data from URL
            player = try AVAudioPlayer(data: audioData) // Initialize player with data
            player?.delegate = self
            player?.volume = 1.0 // Set volume
            player?.play() // Play the soundscape audio
            
            remainingTime = player?.duration ?? 0
            currentTime = 0
            
            startTimer() // Start the timer to update elapsed time
        } catch {
            print("Error playing soundscape: \(error.localizedDescription)")
        }
    }

    // Start timer to track elapsed and remaining time
    private func startTimer() {
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = player.currentTime
            self.remainingTime = player.duration - player.currentTime
        }
    }

    // Stop playback and invalidate timers
    func stopPlayback() {
        player?.stop()
        timer?.invalidate()
        fadeOutTimer?.invalidate()
    }

    // Fade out the sound over time
    func fadeOut(duration: TimeInterval) {
        guard let player = player else { return }
        
        let fadeSteps: Double = 20
        let fadeInterval = duration / fadeSteps
        let volumeStep = player.volume / Float(fadeSteps)

        fadeOutTimer?.invalidate()
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { [weak self] timer in
            if player.volume > 0.05 {
                player.volume -= volumeStep
            } else {
                self?.stopPlayback()
                timer.invalidate()
            }
        }
    }

    // Set sleep timer
    func setSleepTimer(minutes: Int) {
        let sleepTime = TimeInterval(minutes * 60)
        Timer.scheduledTimer(withTimeInterval: sleepTime, repeats: false) { [weak self] _ in
            self?.fadeOut(duration: 60)
        }
    }
}

extension RadioAudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let nextSoundscape = getNextRandomSoundscape(from: soundscapes) {
            playSoundscape(soundscape: nextSoundscape)
        }
    }
}
