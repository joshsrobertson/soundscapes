import SwiftUI

struct BreathingPatternSelectionView: View {
    var selectedSoundscape: String
    var backgroundImage: String
    var isSleepMode: Bool // Add the isSleepMode parameter

    let breathingPatterns = [
        BreathingPattern(id: "In and Out", name: "In and Out Breathing", description: "A simple breathing pattern where you inhale for 4 seconds and exhale for 4 seconds. Helps promote calm and relaxation.", cadence: "4-4"),
        BreathingPattern(id: "Box Breathing", name: "Box Breathing", description: "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps reduce stress and improve focus.", cadence: "4-4-4-4"),
        BreathingPattern(id: "4-7-8 Breathing", name: "4-7-8 Breathing", description: "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Useful for managing anxiety and improving sleep.", cadence: "4-7-8"),
        BreathingPattern(id: "Pursed Lip Breathing", name: "Pursed Lip Breathing", description: "Inhale for 2 seconds, then exhale slowly through pursed lips for 4 seconds. This pattern helps improve lung function and reduces stress.", cadence: "2-4")
    ]

    @State private var isTextVisible = false // Animation for text
    @State private var selectedPageIndex = 0 // Keep track of the page index

    var body: some View {
        ZStack {
            // Full-bleed background image
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Gray overlay for readability
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer() // Add Spacer to push content up

                TabView(selection: $selectedPageIndex) {
                    ForEach(breathingPatterns.indices, id: \.self) { index in
                        let pattern = breathingPatterns[index]
                        VStack(spacing: 20) {
                            Spacer()

                            // Breathing pattern name with animation
                            Text(pattern.name)
                                .font(.custom("Baskerville", size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .multilineTextAlignment(.center)
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 1.5).delay(0.3), value: isTextVisible)

                            // Breathing pattern description with animation
                            Text(pattern.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .multilineTextAlignment(.center)
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 1.5).delay(0.5), value: isTextVisible)

                            Spacer()

                            // Navigation to TimerSelectionView with gradient button
                            NavigationLink(destination: TimerSelectionView(
                                selectedSoundscape: selectedSoundscape,
                                selectedBreathingPattern: pattern,
                                backgroundImage: backgroundImage,
                                isSleepMode: isSleepMode // Pass the isSleepMode parameter
                            )) {
                                Text("Select Breathing Pattern")
                                    .font(.custom("Avenir", size: 16))
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.white.opacity(0.8)) // Change to white background with opacity
                                    .foregroundColor(.black) // Black text
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                            .opacity(isTextVisible ? 1 : 0)
                            .animation(.easeInOut(duration: 1.5).delay(0.7), value: isTextVisible)

                            Spacer()
                        }
                        .tag(index) // Tag to link to the TabView's selection
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Always show the page index circles
                .frame(height: 500) // Adjust the height of the TabView
                .padding(.bottom, 50) // Ensure padding at the bottom so the dots are visible

                Spacer() // Add Spacer below the TabView for spacing
            }
            .padding(.bottom, 50) // Ensure the VStack has some padding at the bottom
        }
        .onAppear {
            // Trigger the text animation
            withAnimation {
                isTextVisible = true
            }
        }
    }
}

struct BreathingPattern: Identifiable {
    var id: String
    var name: String
    var description: String
    var cadence: String
}
