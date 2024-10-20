import SwiftUI

struct SoundscapeSelectionView: View {
    let isBreathingMode: Bool
    let isSleepMode: Bool
    let isJourneyMode: Bool

    let filteredSoundscapes: [Soundscape] // Pass actual soundscapes, not the type

    @State private var selectedSoundscape: Soundscape?
    @State private var isTextVisible = false
    @State private var currentBackgroundImage: String = "IcelandGlacier" // Default starting image
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background image updated dynamically based on selected soundscape
            Image(currentBackgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Gray overlay for text readability
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                TabView(selection: $selectedSoundscape) {
                    ForEach(filteredSoundscapes, id: \.id) { soundscape in
                        VStack(spacing: 20) {
                            Spacer()
                                .frame(height: 50) // Create some space at the top to center content more

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
                            NavigationLink(destination: destinationView(for: soundscape)) {
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

                            Spacer()
                                .frame(height: 60) // Add space before the index dots to match the other view
                        }
                        .tag(soundscape) // Ensure the correct soundscape instance is used here
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 500) // Adjust height of TabView to center better
                
                Spacer()
                    .frame(height: 50) // Add space below the TabView for the dots
            }
        }
        .onAppear {
            withAnimation {
                isTextVisible = true
            }
            selectedSoundscape = filteredSoundscapes.first
            currentBackgroundImage = filteredSoundscapes.first?.imageName ?? "IcelandGlacier"
        }
        .onChange(of: selectedSoundscape) { newSoundscape in
            if let newSoundscape = newSoundscape {
                currentBackgroundImage = newSoundscape.imageName
            }
        }
    }
    
    // Function to determine the destination based on the selected mode
    @ViewBuilder
    func destinationView(for soundscape: Soundscape) -> some View {
        if isBreathingMode {
            BreathingPatternSelectionView(
                selectedSoundscape: soundscape, // Pass the full Soundscape object
                backgroundImage: soundscape.imageName,
                isSleepMode: isSleepMode
            )
        } else if isJourneyMode || isSleepMode {
            TimerSelectionView(
                selectedSoundscape: soundscape, // Pass the full Soundscape object
                selectedBreathingPattern: BreathingPattern(id: "None", name: "No Breathing Pattern", description: "", cadence: ""),
                backgroundImage: soundscape.imageName,
                isSleepMode: isSleepMode,
                isJourneyMode: isJourneyMode,
                isBreathingMode: isBreathingMode
            )
        }
    }
}
