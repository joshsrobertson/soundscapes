import SwiftUI

struct BreathingPatternSelectionView: View {
    var selectedSoundscape: String
    var backgroundImage: String

    let breathingPatterns = [
        BreathingPattern(id: "In and Out", name: "In and Out Breathing", description: "A simple breathing pattern where you inhale for 4 seconds and exhale for 4 seconds. Helps promote calm and relaxation.", cadence: "4-4"),
        BreathingPattern(id: "Box Breathing", name: "Box Breathing", description: "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps reduce stress and improve focus.", cadence: "4-4-4-4"),
        BreathingPattern(id: "4-7-8 Breathing", name: "4-7-8 Breathing", description: "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Useful for managing anxiety and improving sleep.", cadence: "4-7-8"),
        BreathingPattern(id: "Pursed Lip Breathing", name: "Pursed Lip Breathing", description: "Inhale for 2 seconds, then exhale slowly through pursed lips for 4 seconds. This pattern helps improve lung function and reduces stress.", cadence: "2-4")
    ]

    @State private var isTextVisible = false // Animation for text

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
                TabView {
                    ForEach(breathingPatterns, id: \.id) { pattern in
                        VStack(spacing: 20) {
                            Spacer()

                            // Breathing pattern name with animation
                            Text(pattern.name)
                                .font(.custom("Baskerville", size: 36))
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
                                backgroundImage: backgroundImage)) {
                                Text("Select Breathing Pattern")
                                    .font(.custom("Avenir", size: 22))
                                    .padding()
                                    .frame(width: 250)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                                       startPoint: .leading,
                                                       endPoint: .trailing)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .opacity(0.7)
                            }
                            .opacity(isTextVisible ? 1 : 0)
                            .animation(.easeInOut(duration: 1.5).delay(0.7), value: isTextVisible)

                            // Help text: "Swipe for More" on the first pattern
                            if pattern.id == breathingPatterns.first?.id {
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
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Swipeable TabView
            }
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
