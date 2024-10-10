import SwiftUI
import AVKit

struct HomeView: View {
    @State private var player: AVQueuePlayer?
    @State private var isTextVisible = false // For fade-in animation

    var body: some View {
        NavigationView {
            ZStack {
                // Looping video background
                LoopingVideoPlayer(videoName: "IntroVideo", videoType: "mov", player: $player)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(1.0) // Full opacity for the video background

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
                    Text("Soundcape journeys inspired by Nature, designed to connect with your inner Nature.")
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
                            .font(.custom("Avenir", size: 18))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.blue]),
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                                    
                    // Breathe
                    VStack(spacing: 20) {
                        // Breathe Button
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: true, isSleepMode: false)) {
                            Text("Breathe")
                                .font(.custom("Avenir", size: 18))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 200)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)

                        // Sleep Button
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: false, isSleepMode: true)) {
                            Text("Sleep")
                                .font(.custom("Avenir", size: 18))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 200)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)
                    }

                    Spacer() // Push content up for better centering
                    
                }
            }
            .onAppear {
                // Animate text appearance when the view appears
                withAnimation {
                    isTextVisible = true
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
