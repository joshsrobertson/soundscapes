import SwiftUI

struct SoundscapeSelectionView: View {
    let isBreathingMode: Bool // Passed from HomeView to determine the flow

    let soundscapes = [
        Soundscape(id: "Xochimilco", name: "Xochimilco, Mexico", description: "Xochimilco is a wetlands area in Mexico City that contains the last remnants of an Ancient Aztec canal system. The area is home to diverse wildlife including the regenerative axolotl, and is critical to the Mexico City ecosystem.", imageName: "Xochimilco"),
        Soundscape(id: "Ocean Waves", name: "Ocean Waves", description: "Relaxing sounds of the ocean.", imageName: "OceanWaves"),
        Soundscape(id: "Electronic", name: "Electronic", description: "Soothing electronic ambient music.", imageName: "Electronic")
    ]
    
    @State private var selectedSoundscape: Soundscape?
    @Environment(\.presentationMode) var presentationMode // To go back to HomeView

    var body: some View {
        ZStack {
            TabView {
                ForEach(Array(soundscapes.enumerated()), id: \.element.id) { index, soundscape in
                    ZStack {
                        // Full-bleed background image
                        Image(soundscape.imageName)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all) // Make the image bleed to top and bottom
                        
                        VStack(spacing: 20) {
                            Spacer()

                            // Soundscape Name
                            Text(soundscape.name)
                                .font(.custom("Avenir", size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            // Soundscape Description
                            Text(soundscape.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(10)
                                .frame(width: 300)

                            Spacer()

                            // Select Soundscape Button
                            if isBreathingMode {
                                NavigationLink(destination: BreathingPatternSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    backgroundImage: soundscape.imageName)) {
                                    Text("Select Soundscape")
                                        .font(.custom("Avenir", size: 22))
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200)
                                        .background(Color.white.opacity(0.8))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                            } else {
                                NavigationLink(destination: TimerSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    selectedBreathingPattern: BreathingPattern(id: "None", name: "No Breathing Pattern", description: "", cadence: ""),
                                    backgroundImage: soundscape.imageName)) {
                                    Text("Select Soundscape")
                                        .font(.custom("Avenir", size: 22))
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200)
                                        .background(Color.white.opacity(0.8))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                            }

                            // Help text only on the first soundscape
                            if index == 0 {
                                Text("Swipe to Explore More")
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                            }

                            Spacer()
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Swipeable TabView

            // Custom Back button
            VStack {
                HStack {
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
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true) // Remove the navigation bar to make the image bleed
    }
}

struct Soundscape: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageName: String
}
