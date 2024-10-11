import SwiftUI
import AVKit

struct HomeView: View {
    @State private var player: AVQueuePlayer?
    @State private var isTextVisible = false // For fade-in animation

    var body: some View {
        NavigationView {
            ZStack {
                // Looping video background
                LoopingVideoPlayer(videoName: "IntroVideo", videoType: "mp4", player: $player)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8) // Full opacity for the video background

                VStack(spacing: 20) {
                    Spacer() // Push content down for better centering

                    // App Title
                    Text("Sound Journeys")
                        .font(.custom("Baskerville", size: 40)) // Avenir font for a sleek look
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(isTextVisible ? 1 : 0) // Control opacity with isTextVisible
                        .animation(.easeInOut(duration: 1), value: isTextVisible) // Animate text appearance

                    // App Description
                    Text("Soundscape journeys inspired by Nature, designed to connect with your inner Nature.")
                        .font(.custom("Avenir", size: 20)) // Avenir for the description as well
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 30)
                        .opacity(isTextVisible ? 1 : 0) // Control opacity with isTextVisible
                        .animation(.easeInOut(duration: 3), value: isTextVisible) // Slightly different timing

                    Text("Choose your journey.")
                        .font(.custom("Avenir", size: 18)) // Avenir for the description as well
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(isTextVisible ? 1 : 0) // Control opacity with isTextVisible
                        .animation(.easeInOut(duration: 5), value: isTextVisible) // Another staggered delay

                    // Explore Button
                    NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: false, isSleepMode: false)) {
                        Text("Explore")
                            .font(.custom("Avenir", size: 16))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200)
                            .background(Color.white.opacity(0.8)) // Change to white background with opacity
                            .foregroundColor(.black) // Black text
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                    // Breathe and Sleep Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: true, isSleepMode: false)) {
                            Text("Breathe")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 200)
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)

                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: false, isSleepMode: true)) {
                            Text("Sleep")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 200)
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)
                    }

                    Spacer() // Push content up for better centering
                }
            }
            .onAppear {
                withAnimation {
                    isTextVisible = true
                }

                if let player = player {
                    player.play()
                } else {
                    let url = Bundle.main.url(forResource: "IntroVideo", withExtension: "mp4")!
                    let playerItem = AVPlayerItem(url: url)
                    let queuePlayer = AVQueuePlayer(playerItem: playerItem)

                    // Apply this to disable PiP and AirPlay behavior
                    let playerLayer = AVPlayerLayer(player: queuePlayer)
                    playerLayer.player?.allowsExternalPlayback = false
                    playerLayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = false

                    player = queuePlayer
                    queuePlayer.play()
                }
            }
            .onDisappear {
                player?.pause()
            }
            .navigationBarHidden(true) // Hide the navigation bar on the intro screen
        }
    }
}
