import SwiftUI

struct BreathingPatternSelectionView: View {
    var selectedSoundscape: String // Passed in from SoundscapeSelectionView
    let breathingPatterns = [
        BreathingPattern(id: "Box Breathing", name: "Box Breathing", description: "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps reduce stress and improve focus.", cadence: "4-4-4-4"),
        BreathingPattern(id: "4-7-8 Breathing", name: "4-7-8 Breathing", description: "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Useful for managing anxiety and improving sleep.", cadence: "4-7-8"),
        BreathingPattern(id: "None", name: "No Breathing Pattern", description: "Listen to the soundscape only, without a breathing exercise.", cadence: "")
    ]

    var body: some View {
        NavigationView {
            TabView {
                ForEach(breathingPatterns, id: \.id) { pattern in
                    ZStack {
                        Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Spacer()

                            Text(pattern.name)
                                .font(.custom("Avenir", size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            Text(pattern.description)
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)

                            Spacer()

                            NavigationLink(destination: TimerSelectionView(selectedSoundscape: selectedSoundscape, selectedBreathingPattern: pattern)) {
                                Text("Select \(pattern.name)")
                                    .font(.custom("Avenir", size: 22))
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

struct BreathingPattern: Identifiable {
    var id: String
    var name: String
    var description: String
    var cadence: String
}
