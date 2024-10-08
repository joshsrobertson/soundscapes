import SwiftUI

struct HomeView: View {
    @State private var selectedMode: String? // Tracks which mode is selected: Breath or Relax|Sleep

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

                    // Mode Selection Buttons
                    VStack(spacing: 20) {
                        Text("Choose Your Mode")
                            .font(.custom("Avenir", size: 24))
                            .foregroundColor(.white)

                        // Breath Mode Button
                        Button(action: {
                            selectedMode = "Breath"
                        }) {
                            Text("Breath")
                                .font(.custom("Avenir", size: 22))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)

                        // Relax|Sleep Mode Button
                        Button(action: {
                            selectedMode = "Relax|Sleep"
                        }) {
                            Text("Relax | Sleep")
                                .font(.custom("Avenir", size: 22))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 20)

                    // Proceed Button based on the mode selected
                    if let mode = selectedMode {
                        NavigationLink(destination: SoundscapeSelectionView(isBreathingMode: mode == "Breath")) {
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
                    }

                    Spacer() // Push content up for better centering
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar on the intro screen
        }
    }
}
