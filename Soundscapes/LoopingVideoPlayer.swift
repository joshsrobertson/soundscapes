import SwiftUI
import AVFoundation
import AVKit

struct LoopingVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoType: String

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            fatalError("Video file \(videoName).\(videoType) not found")
        }

        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        context.coordinator.looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)

        playerViewController.player = queuePlayer
        playerViewController.showsPlaybackControls = false

        // Start video playback
        queuePlayer.play()

        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No update needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var looper: AVPlayerLooper?
    }
}
