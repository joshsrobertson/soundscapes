import AVFoundation
import SwiftUI

class BreathingManager: ObservableObject {
    // Breathing Sounds
    var inhalePlayer: AVAudioPlayer?
    var exhalePlayer: AVAudioPlayer?
    @Published var isMuted: Bool = true

    // Breathing Patterns
    @Published var breathingPhase: String = "Inhale"
    @Published var circleScale: CGFloat = 0.8
    private var soundManager: BreathingManager?

    init() {
        setupAudioSession()
        loadSounds()
    }

    // Setup Audio Session
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

    // Load Inhale and Exhale sounds
    private func loadSounds() {
        if let inhaleURL = Bundle.main.url(forResource: "inhaleSound", withExtension: "mp3") {
            inhalePlayer = try? AVAudioPlayer(contentsOf: inhaleURL)
            inhalePlayer?.prepareToPlay()
        }
        
        if let exhaleURL = Bundle.main.url(forResource: "exhaleSound", withExtension: "mp3") {
            exhalePlayer = try? AVAudioPlayer(contentsOf: exhaleURL)
            exhalePlayer?.prepareToPlay()
        }
    }

    // Play Inhale Sound
    func playInhaleSound() {
        guard !isMuted else { return }
        inhalePlayer?.currentTime = 0
        inhalePlayer?.volume = 0.7
        inhalePlayer?.play()
    }

    // Play Exhale Sound
    func playExhaleSound() {
        guard !isMuted else { return }
        exhalePlayer?.currentTime = 0
        exhalePlayer?.volume = 0.7
        exhalePlayer?.play()
    }

    // Fade Out Inhale
    func fadeOutInhale() {
        fadeOut(player: inhalePlayer)
    }

    // Fade Out Exhale
    func fadeOutExhale() {
        fadeOut(player: exhalePlayer)
    }

    private func fadeOut(player: AVAudioPlayer?) {
        guard let player = player, !isMuted else { return }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if player.volume > 0.1 {
                player.volume -= 0.1
            } else {
                player.stop()
                timer.invalidate()
            }
        }
    }

    // Toggle Mute
    func toggleMute() {
        isMuted.toggle()
        inhalePlayer?.volume = isMuted ? 0 : 1
        exhalePlayer?.volume = isMuted ? 0 : 1
    }

    // Stop All Sounds
    func stopAllSounds() {
        inhalePlayer?.stop()
        exhalePlayer?.stop()
    }

    // Update Breathing Phase and Circle Animation
    func updateBreathingPhase(selectedBreathingPattern: BreathingPattern, remainingTime: Int, cycleStartTime: Int?) {
        guard let cycleStartTime = cycleStartTime else { return }
        let timeElapsed = cycleStartTime - remainingTime
        
        switch selectedBreathingPattern.id {
        case "Box Breathing":
            let cycleLength = 16
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2
                playInhaleSound()
            } else if phaseTime < 8 {
                breathingPhase = "Hold"
                circleScale = 1.2
                fadeOutInhale()
            } else if phaseTime < 12 {
                breathingPhase = "Exhale"
                circleScale = 0.8
                playExhaleSound()
            } else {
                breathingPhase = "Hold"
                circleScale = 0.8
                fadeOutExhale()
            }
        case "In and Out":
            let cycleLength = 8
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2
                playInhaleSound()
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8
                playExhaleSound()
            }
        
        case "4-7-8 Breathing":
            let cycleLength = 19
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2
                playInhaleSound()
            } else if phaseTime < 11 {
                breathingPhase = "Hold"
                circleScale = 1.2
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8
                playExhaleSound()
            }
        
        case "Pursed Lip Breathing":
            let cycleLength = 6
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 2 {
                breathingPhase = "Inhale"
                circleScale = 1.2
                playInhaleSound()
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8
                playExhaleSound()
            }
        
        default:
            breathingPhase = "Inhale"
            circleScale = 1.2
        }
    }
}
