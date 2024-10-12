import SwiftUI

struct CategorySelectionView: View {
    let isBreathingMode: Bool
    let isSleepMode: Bool
    let isJourneyMode: Bool

    // State to track the random background image from all soundscapes
    @State private var selectedSoundscapeImage: String = ""

    var body: some View {
        ZStack {
            // Background image randomly selected from soundscapes
            if !selectedSoundscapeImage.isEmpty {
                Image(selectedSoundscapeImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image("NatureSoundsBackground") // Provide a default background
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            
            // Gray overlay for better readability of text
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Moving the content up slightly by adding padding at the bottom
                Spacer()
                    .frame(height: 170) // Adjust the height to control how far up the content is moved

                Text("Choose a Soundscape Category")
                    .font(.custom("Avenir", size: 18))
                    .foregroundColor(.white)
                
                // Category Buttons (each button navigates to the next step)
                categoryButton(category: "Nature Sounds", label: "Nature Sounds", icon: "leaf.fill")
                categoryButton(category: "Nature and Music", label: "Nature and Music", icon: "music.note")
                categoryButton(category: "Sound Healing", label: "Sound Healing", icon: "circle.grid.hex.fill") // Bowl-like icon
                categoryButton(category: "Ambient Electronic", label: "Ambient Electronic", icon: "antenna.radiowaves.left.and.right")
                
                Spacer() // This spacer will help center the content vertically
            }
            .onAppear {
                // Set a random background image from the soundscapes
                selectedSoundscapeImage = getRandomImage()
            }
        }
    }

    // Button for categories with navigation to SoundscapeSelectionView
    @ViewBuilder
    func categoryButton(category: String, label: String, icon: String) -> some View {
        NavigationLink(destination: SoundscapeSelectionView(
            isBreathingMode: isBreathingMode,
            isSleepMode: isSleepMode,
            isJourneyMode: isJourneyMode,
            filteredSoundscapes: soundscapes.filter { $0.category.contains(category) }
        )) {
            HStack {
                // Category icon on the left side
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.black)

                Spacer()

                // Category text
                Text(label)
                    .font(.custom("Avenir", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Spacer()

                // Indicator showing the number of soundscapes in the category with wave icon
                HStack(spacing: 5) {
                    Text("\(soundscapes.filter { $0.category.contains(category) }.count)")
                        .font(.custom("Avenir", size: 14))
                        .foregroundColor(.black)
                    Image(systemName: "waveform.path")
                        .font(.custom("Avenir", size: 14))
                        .foregroundColor(.black)
                }
            }
            .padding()
            .frame(width: 300) // Adjust the frame width to 300
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }

    // Function to get a random image from any soundscape
    func getRandomImage() -> String {
        return soundscapes.randomElement()?.imageName ?? "Xochimilco" // Default background if none found
    }
}
