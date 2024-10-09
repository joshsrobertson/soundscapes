import SwiftUI
import AVKit

struct LoopingVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoType: String
    @Binding var player: AVQueuePlayer? // Allow HomeView to control the player

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()

        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            fatalError("Video file \(videoName).\(videoType) not found")
        }

        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)

        // Loop the video
        let looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        context.coordinator.looper = looper

        playerViewController.player = queuePlayer
        playerViewController.showsPlaybackControls = false

        // Start the video playback and bind the player
        queuePlayer.play()
        DispatchQueue.main.async {
            self.player = queuePlayer
        }

        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var looper: AVPlayerLooper?
    }
}
