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
                    .opacity(1) // Full opacity for the video background

                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 210)
                    Text("Choose your path.")
                        .font(.custom("Avenir", size: 16)) // Avenir for the description as well
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(isTextVisible ? 1 : 0) // Control opacity with isTextVisible
                        .animation(.easeInOut(duration: 5), value: isTextVisible) // Another staggered delay

                    // Journey Button with icon
                    NavigationLink(destination: CategorySelectionView(isBreathingMode: false, isSleepMode: false, isJourneyMode: true)) {
                        HStack {
                            Image(systemName: "map") // Icon for journey
                                .font(.title2)
                                .foregroundColor(.black)
                                
                            Text("Journey")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.semibold)
                        }
                        .padding(.trailing, 15) // Adjust padding to nudge text left
                        .padding()
                        .frame(width: 200)
                        .background(Color.white.opacity(0.8)) // Change to white background with opacity
                        .foregroundColor(.black) // Black text
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                    // Breathe and Sleep Buttons with icons
                    VStack(spacing: 20) {
                        NavigationLink(destination: CategorySelectionView(isBreathingMode: true, isSleepMode: false, isJourneyMode: false)) {
                            HStack {
                                Image(systemName: "wind") // Icon for breathe
                                    .font(.title2)
                                    .foregroundColor(.black)
                                   
                                Text("Breathe")
                                    .font(.custom("Avenir", size: 16))
                                    .fontWeight(.semibold)
                            }
                            .padding(.trailing, 15) // Adjust padding to nudge text left
                            .padding()
                            .frame(width: 200)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)

                        NavigationLink(destination: CategorySelectionView(isBreathingMode: false, isSleepMode: true, isJourneyMode: false)) {
                            HStack {
                                Image(systemName: "moon.stars.fill") // Icon for sleep
                                    .font(.title2)
                                    .foregroundColor(.black)
                                   
                                Text("Sleep")
                                    .font(.custom("Avenir", size: 16))
                                    .fontWeight(.semibold)
                            }
                            .padding(.trailing, 15) // Adjust padding to nudge text left
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

/*#Preview {
    HomeView()
}
*/
