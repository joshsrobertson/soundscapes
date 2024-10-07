import SwiftUI
import AVKit

struct LoopingVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoType: String

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            fatalError("Video file not found: \(videoName).\(videoType)")
        }

        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        let looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)

        playerViewController.player = queuePlayer
        playerViewController.showsPlaybackControls = false
        queuePlayer.play()

        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No update needed
    }
}
