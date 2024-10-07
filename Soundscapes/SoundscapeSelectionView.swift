import SwiftUI

struct SoundscapeSelectionView: View {
    let soundscapes = [
        Soundscape(id: "Xochimilco", name: "Xochimilco, Mexico", description: "Xochimilco is a wetlands area in Mexico City that contains the last remnants of an Ancient Aztec canal system. The area is home to diverse wildlife including the regenerative axolotl, and is critical to the Mexico City ecosystem.", imageName: "Xochimilco"),
        Soundscape(id: "Ocean Waves", name: "Ocean Waves", description: "Relaxing sounds of the ocean.", imageName: "OceanWaves"),
        Soundscape(id: "Electronic", name: "Electronic", description: "Soothing electronic ambient music.", imageName: "Electronic")
    ]
    
    @State private var selectedSoundscape: Soundscape?

    var body: some View {
        ZStack {
            TabView {
                ForEach(soundscapes, id: \.id) { soundscape in
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

                            // Select Button - Navigate to BreathingPatternSelectionView
                            NavigationLink(destination: BreathingPatternSelectionView(selectedSoundscape: soundscape.id, backgroundImage: soundscape.imageName)) {
                                Text("Select \(soundscape.name)")
                                    .font(.custom("Avenir", size: 22))
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.white.opacity(0.8))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Swipeable TabView
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
