import SwiftUI

struct SoundscapeSelectionView: View {
    let isBreathingMode: Bool // Passed from HomeView to determine the flow

    let soundscapes = [
        Soundscape(id: "OceanWaves", name: "Big Sur Ocean Waves", description: "Enjoy the relaxing sounds of waves crashing in Big Sur, California", imageName: "OceanWaves"),
        Soundscape(id: "Xochimilco", name: "Xochimilco Sunrise", description: "The soothing morning sounds of a protected wetlands area in Mexico City home to diverse wildlife including the regenerative axolotl.", imageName: "Xochimilco"),
        Soundscape(id: "Electronic", name: "Outer Space Frequencies", description: "An intriguing soundscape created from source sounds provided by NASA from the processed frequencies of outerspace", imageName: "Electronic")
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
                                .frame(width: 300)

                            // Soundscape Description
                            Text(soundscape.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .padding(10)
                                .multilineTextAlignment(.center)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .frame(width: 300)

                            Spacer()

                            // Select Soundscape Button
                            if isBreathingMode {
                                NavigationLink(destination: BreathingPatternSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    backgroundImage: soundscape.imageName)) {
                                    Text("Choose Soundscape")
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
                                Text("Swipe for More")
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
