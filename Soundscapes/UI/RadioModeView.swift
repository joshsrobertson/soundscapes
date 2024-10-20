import SwiftUI
import Kingfisher

struct RadioModeView: View {
    @StateObject var radioAudioManager = RadioAudioManager()
    @State private var selectedSoundscape: Soundscape? // Store the current soundscape being played
    @State private var remainingTimeString = ""

    var body: some View {
        ZStack {
            // Background image using Kingfisher
            if let selectedSoundscape = selectedSoundscape {
                KFImage(URL(string: selectedSoundscape.imageURL)) // Use Kingfisher to load the image from S3
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }

            // Black overlay for better text readability
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Spacer() // To push content up slightly

                // Soundscape name and description
                if let selectedSoundscape = selectedSoundscape {
                    Text(selectedSoundscape.name)
                        .font(.custom("Baskerville", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Text(selectedSoundscape.description)
                        .font(.custom("Avenir", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // Display remaining time for the audio
                if radioAudioManager.remainingTime > 0 {
                    Text("Time Remaining: \(formatTime(radioAudioManager.remainingTime))")
                        .font(.custom("Avenir", size: 18))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }

                // Move the buttons closer to the center
                VStack(spacing: 20) {
                    // Button to play the next soundscape
                    Button(action: {
                        playNextSoundscape()
                    }) {
                        HStack {
                            Image(systemName: "forward.fill") // Button icon for next soundscape
                                .font(.title2)
                                .foregroundColor(.black)
                            Text("Next Soundscape")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 250)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }

                    // Stop button to end the radio session
                    Button(action: {
                        radioAudioManager.stopPlayback()
                    }) {
                        Text("Stop Radio")
                            .font(.custom("Avenir", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(width: 150)
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 50) // Adjust padding to move buttons closer to the center

                Spacer()
            }
            .onAppear {
                playNextSoundscape() // Start by playing a random soundscape on view load
            }
        }
    }

    // Helper function to format time in mm:ss
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Helper function to play the next random soundscape
    private func playNextSoundscape() {
        // Get the next random soundscape and play it
        if let nextSoundscape = radioAudioManager.getNextRandomSoundscape(from: soundscapes) {
            selectedSoundscape = nextSoundscape // Set the visual elements
            radioAudioManager.playSoundscape(soundscape: nextSoundscape) // Sync the audio
        }
    }
}
