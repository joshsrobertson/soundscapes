import SwiftUI

struct SoundscapeSelectionView: View {
    let isBreathingMode: Bool

    let soundscapes = [
        Soundscape(id: "Xochimilco", name: "Xochimilco Piano Sunrise", description: "The soothing morning nature sounds of a protected wetland area in Mexico City with gentle piano.", imageName: "Xochimilco"),
        Soundscape(id: "OceanWaves", name: "Big Sur Ocean Waves", description: "Enjoy the relaxing sounds of waves crashing in Big Sur, California", imageName: "OceanWaves"),
        Soundscape(id: "Electronic", name: "Outer Space Frequencies", description: "An intriguing soundscape created from source sounds provided by NASA from the processed frequencies of outerspace", imageName: "Electronic")
    ]

    @State private var selectedSoundscape: Soundscape?
    @State private var isTextVisible = false // Animation for text
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            TabView {
                ForEach(Array(soundscapes.enumerated()), id: \.element.id) { index, soundscape in
                    ZStack {
                        // Full-bleed background image
                        Image(soundscape.imageName)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        
                        // Gray overlay to enhance text readability
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Spacer()

                            // Soundscape Name with animation
                            Text(soundscape.name)
                                .font(.custom("Baskerville", size: 36))
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

                            // Select Soundscape Button with gradient
                            if isBreathingMode {
                                NavigationLink(destination: BreathingPatternSelectionView(
                                    selectedSoundscape: soundscape.id,
                                    backgroundImage: soundscape.imageName)) {
                                    Text("Choose Soundscape")
                                        .font(.custom("Avenir", size: 22))
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .opacity(0.7)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
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
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                }
                            }

                            // Help text only on the first soundscape
                            if index == 0 {
                                Text("Swipe for More")
                                    .font(.custom("Avenir", size: 20))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                    .fontWeight(.bold)
                                    .opacity(isTextVisible ? 1 : 0)
                                    .animation(.easeInOut(duration: 1.5).delay(0.8), value: isTextVisible)
                                Image(systemName: "arrow.right")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .opacity(isTextVisible ? 1 : 0)
                                    .animation(.easeInOut(duration: 1.5).delay(1.0), value: isTextVisible)
                            }

                            Spacer()
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

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
