import SwiftUI
import Kingfisher // Import Kingfisher

struct CategorySelectionView: View {
    let isBreathingMode: Bool
    let isSleepMode: Bool
    let isJourneyMode: Bool

    // State to track the random background image URL from all soundscapes
    @State private var selectedSoundscapeImageURL: String = ""

    var body: some View {
        ZStack {
            // Background image randomly selected from soundscapes using Kingfisher
            if !selectedSoundscapeImageURL.isEmpty {
                KFImage(URL(string: selectedSoundscapeImageURL)) // Load image from S3 URL
                    .resizable()
                    .placeholder { // Display a ProgressView while loading
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all) // Background color while loading
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(2) // Make the loading circle larger
                        }
                    }
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image("NatureSoundsBackground") // Provide a default background
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }

            // Gray overlay for better readability of text
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                // Moving the content up slightly by adding padding at the bottom
                Spacer()
                    .frame(height: 100) // Adjust the height to control how far up the content is moved

                Text("Choose a Soundscape Category")
                    .font(.custom("Avenir", size: 18))
                    .foregroundColor(.white)

                // Category Buttons (each button navigates to the next step)
                categoryButton(category: "All Soundscapes", label: "All Soundscapes", icon: "list.bullet")
                categoryButton(category: "Nature Sounds", label: "Pure Nature Sounds", icon: "leaf.fill")
                categoryButton(category: "Nature Music", label: "Nature Music", icon: "music.note")
                categoryButton(category: "Sound Healing", label: "Sound Healing", icon: "circle.grid.hex.fill") // Bowl-like icon
                categoryButton(category: "Ambient Electronic", label: "Ambient Electronic", icon: "antenna.radiowaves.left.and.right")
                categoryButton(category: "City Sounds", label: "City Sounds", icon: "building.2.crop.circle.fill")

                Spacer() // This spacer will help center the content vertically
            }
            .onAppear {
                // Set a random background image URL from the soundscapes
                selectedSoundscapeImageURL = getRandomImageURL()
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
            filteredSoundscapes: getFilteredSoundscapes(for: category) // Get filtered soundscapes based on category
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

                // Indicator showing the number of soundscapes in the category with wave icon
                HStack(spacing: 5) {
                    Text("\(getFilteredSoundscapes(for: category).count)")
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

    // Function to get a random image URL from any soundscape
    func getRandomImageURL() -> String {
        return soundscapes.randomElement()?.imageURL ?? "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/Xochimilco.jpg" // Default image URL
    }

    // Function to get filtered soundscapes based on the category
    func getFilteredSoundscapes(for category: String) -> [Soundscape] {
        if category == "All Soundscapes" {
            return soundscapes.shuffled() // Return all soundscapes in a random order
        } else {
            return soundscapes.filter { $0.category.contains(category) }.shuffled() // Shuffle the filtered soundscapes
        }
    }
}
