import SwiftUI

struct SoundscapeSelectionView: View {
    let soundscapes = [
        Soundscape(id: "Nature", name: "Nature", description: "Relaxing sounds of nature.", imageName: "Nature"),
        Soundscape(id: "Electronic", name: "Electronic", description: "Soothing electronic ambient music.", imageName: "Electronic"),
        Soundscape(id: "Xochimilco", name: "Xochimilco, Mexico", description: "Sounds of the canals in Xochimilco.", imageName: "Xochimilco")
    ]
    
    @State private var selectedSoundscape: Soundscape?

    var body: some View {
        NavigationView {
            TabView {
                ForEach(soundscapes, id: \.id) { soundscape in
                    ZStack {
                        // Full-bleed background image
                        Image(soundscape.imageName)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

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

                            Spacer()

                            // Select Button - Navigate to BreathingPatternSelectionView
                            NavigationLink(destination: BreathingPatternSelectionView(selectedSoundscape: soundscape.id)) {
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
            .navigationBarTitle("Soundscapes", displayMode: .inline)
        }
    }
}

struct Soundscape: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageName: String
}
