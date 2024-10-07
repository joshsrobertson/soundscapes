import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Looping video background
                LoopingVideoPlayer(videoName: "IntroVideo", videoType: "mov")
                    .edgesIgnoringSafeArea(.all)
                    .opacity(1.0) // Full opacity for the video background

                VStack(spacing: 20) {
                    Spacer() // Push content down for better centering

                    // App Title
                    Text("Welcome to Soundscapes")
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

                    // Let's Get Started Button
                    NavigationLink(destination: SoundscapeSelectionView()) {
                        Text("Let's Get Started")
                            .font(.custom("Avenir", size: 22)) // Avenir for button text
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)

                    Spacer() // Push content up for better centering
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar on the intro screen
        }
    }
}
