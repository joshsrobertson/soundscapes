import SwiftUI

struct BreathingPatternSelectionView: View {
    var selectedSoundscape: String
    var backgroundImage: String // Add background image parameter

    let breathingPatterns = [
        BreathingPattern(id: "None", name: "Swipe To Add A Breathing Pattern", description: "", cadence: ""),
        BreathingPattern(id: "Box Breathing", name: "Box Breathing", description: "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps reduce stress and improve focus.", cadence: "4-4-4-4"),
        BreathingPattern(id: "4-7-8 Breathing", name: "4-7-8 Breathing", description: "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Useful for managing anxiety and improving sleep.", cadence: "4-7-8"),
        BreathingPattern(id: "In and Out", name: "In and Out Breathing", description: "Breathe in for 4 seconds and out for 4 seconds. A simple and steady breathing exercise to promote relaxation.", cadence: "4-4"),
        BreathingPattern(id: "Pursed Lip Breathing", name: "Pursed Lip Breathing", description: "Inhale through the nose for 2 seconds and exhale slowly through pursed lips for 4 seconds. Helps improve lung function and promote calmness.", cadence: "2-4")
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

                            Text(pattern.name)
                                .font(.custom("Avenir", size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .multilineTextAlignment(.center)

                            Text(pattern.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .frame(width: 300)

                            Spacer()

                            NavigationLink(destination: TimerSelectionView(selectedSoundscape: selectedSoundscape, selectedBreathingPattern: pattern, backgroundImage: backgroundImage)) {
                                Text(pattern.id == "None" ? "Continue with No Breathing Pattern" : "Select \(pattern.name)")
                                    .font(.custom("Avenir", size: 22))
                                    .padding()
                                    .frame(width: 250)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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
