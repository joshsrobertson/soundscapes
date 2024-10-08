import SwiftUI
import AVKit

struct HomeView: View {
    @State private var player: AVQueuePlayer?

    var body: some View {
        NavigationView {
            ZStack {
                // Looping video background
                LoopingVideoPlayer(videoName: "IntroVideo", videoType: "mov", player: $player)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(1.0) // Full opacity for the video background

                VStack(spacing: 15) {
                    Spacer() // Push content down for better centering

                    // App Title
                    Text("Sound.Scapes")
                        .font(.custom("Avenir", size: 40)) // Avenir font for a sleek look
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // App Description
                    Text("Explore immersive soundscapes and soothing breathing exercises designed to help you unwind and rejuvenate.")
                        .font(.custom("Avenir", size: 18)) // Avenir for the description as well
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .fontWeight(.bold)
                    Text("Choose your journey.")
                        .font(.custom("Avenir", size: 18)) // Avenir for the description as well
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    // Relax|Sleep and Breath options
                    VStack(spacing: 20) {
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: true)) {
                            Text("Breathe")
                                .font(.custom("Avenir", size: 18)) // Avenir for button text
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                    }
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: false)) {
                            Text("Relax | Sleep")
                                .font(.custom("Avenir", size: 18)) // Avenir for button text
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)

                      
                    Spacer() // Push content up for better centering
                }
            }
            .onAppear {
                if let player = player {
                    // Resume playing if the player exists
                    player.play()
                } else {
                    // Create the player again if it doesn't exist (in case of a fresh launch)
                    let url = Bundle.main.url(forResource: "IntroVideo", withExtension: "mov")!
                    let playerItem = AVPlayerItem(url: url)
                    let queuePlayer = AVQueuePlayer(playerItem: playerItem)
                    player = queuePlayer
                    queuePlayer.play()
                }
            }
            .onDisappear {
                // Pause the video playback when navigating away
                player?.pause()
            }
            .navigationBarHidden(true) // Hide the navigation bar on the intro screen
        }
    }
}
