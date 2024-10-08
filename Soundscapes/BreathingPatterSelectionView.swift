import SwiftUI

struct BreathingPatternSelectionView: View {
    var selectedSoundscape: String
    var backgroundImage: String // Add background image parameter

    let breathingPatterns = [
        BreathingPattern(id: "In and Out", name: "In and Out Breathing", description: "A simple breathing pattern where you inhale for 4 seconds and exhale for 4 seconds. Helps promote calm and relaxation.", cadence: "4-4"),
        BreathingPattern(id: "Box Breathing", name: "Box Breathing", description: "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps reduce stress and improve focus.", cadence: "4-4-4-4"),
        BreathingPattern(id: "4-7-8 Breathing", name: "4-7-8 Breathing", description: "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Useful for managing anxiety and improving sleep.", cadence: "4-7-8"),
        BreathingPattern(id: "Pursed Lip Breathing", name: "Pursed Lip Breathing", description: "Inhale for 2 seconds, then exhale slowly through pursed lips for 4 seconds. This pattern helps improve lung function and reduces stress.", cadence: "2-4")
    ]

    var body: some View {
        ZStack {
            // Full-bleed background image
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                TabView {
                    ForEach(breathingPatterns, id: \.id) { pattern in
                        VStack(spacing: 20) {
                            Spacer()

                            // Breathing pattern name
                            Text(pattern.name)
                                .font(.custom("Avenir", size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .multilineTextAlignment(.center)

                            // Breathing pattern description
                            Text(pattern.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .padding(10)
                                .multilineTextAlignment(.center)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .frame(width: 300)
                                

                            Spacer()

                            // Navigation to TimerSelectionView
                            NavigationLink(destination: TimerSelectionView(
                                selectedSoundscape: selectedSoundscape,
                                selectedBreathingPattern: pattern,
                                backgroundImage: backgroundImage)) {
                                Text("Select Breathing Pattern")
                                    .font(.custom("Avenir", size: 22))
                                    .padding()
                                    .frame(width: 250)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            // Help text: "Swipe for More"
                            if pattern.id == breathingPatterns.first?.id {
                                Text("Swipe for More")
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                            }

                            Spacer()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Swipeable TabView
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
