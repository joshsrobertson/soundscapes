import SwiftUI

struct SoundscapeSelectionView: View {
    let isBreathingMode: Bool // Passed from HomeView to determine the flow
    let isSleepMode: Bool // New parameter to determine if Sleep mode is active

    let soundscapes = [
        Soundscape(id: "IcelandGlacier", name: "Iceland Glacier", description: "The sounds of an ice cave deep within the Vatnajökull Glacier, with cave vocals.", imageName: "IcelandGlacier"),
        Soundscape(id: "Xochimilco", name: "Xochimilco Piano Sunrise", description: "The sunrise nature sounds of a protected wetland area in Mexico City with gentle piano.", imageName: "Xochimilco"),
        Soundscape(id: "OceanWaves", name: "Big Sur Ocean Waves", description: "Enjoy the relaxing sounds of waves crashing in Big Sur, California", imageName: "OceanWaves"),
        Soundscape(id: "Electronic", name: "Outer Space Frequencies", description: "An intriguing soundscape created from source sounds provided by NASA from the processed frequencies of outer space", imageName: "Electronic")
    ]

    @State private var selectedSoundscape: Soundscape?
    @State private var isTextVisible = false // Animation for text
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background image outside the TabView to ensure full-bleed across all tabs
            Image(selectedSoundscape?.imageName ?? soundscapes[0].imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Gray overlay for text readability
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    // Custom Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Navigate back to HomeView
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Home")
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    Spacer()
                }
                .padding(.top, 40) // Add padding to push down the back button

              

                TabView {
                    ForEach(Array(soundscapes.enumerated()), id: \.element.id) { index, soundscape in
                        VStack(spacing: 20) {
                            Spacer()

                            // Soundscape Name with animation
                            Text(soundscape.name)
                                .font(.custom("Baskerville", size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 1.5).delay(0.3), value: isTextVisible)

                            // Soundscape Description with animation
                            Text(soundscape.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 1.5).delay(0.5), value: isTextVisible)

                            Spacer()

                            // Select Soundscape Button
                            if isBreathingMode {
                                NavigationLink(destination: BreathingPatternSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    backgroundImage: soundscape.imageName,
                                    isSleepMode: isSleepMode // Pass the isSleepMode flag
                                )) {
                                    Text("Select Soundscape")
                                        .font(.custom("Avenir", size: 16))
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200)
                                        .background(Color.white.opacity(0.8))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                }
                            } else {
                                NavigationLink(destination: TimerSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    selectedBreathingPattern: BreathingPattern(id: "None", name: "No Breathing Pattern", description: "", cadence: ""),
                                    backgroundImage: soundscape.imageName,
                                    isSleepMode: isSleepMode // Pass the isSleepMode flag
                                )) {
                                    Text("Select Soundscape")
                                        .font(.custom("Avenir", size: 16))
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200)
                                        .background(Color.white.opacity(0.8))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                }
                            }

                            Spacer()
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 500) // Adjust height of TabView to center better

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Trigger the text animation
            withAnimation {
                isTextVisible = true
            }
        }
    }
}

struct Soundscape: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageName: String
}
