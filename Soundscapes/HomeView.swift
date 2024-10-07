import SwiftUI

struct HomeView: View {
    @State private var selectedSoundscape: String = "Nature"
    @State private var selectedBreathingPattern: String = "None" // Default to no breathing pattern
    @State private var selectedBreathingOverlay: String = "None" // Default to no breathing sound overlay
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to SoundscapesApp")
                    .font(.largeTitle)
                    .padding()

                // Soundscape Selection
                Text("Select a Soundscape:")
                    .font(.headline)
                    .padding(.top)

                Picker("Soundscapes", selection: $selectedSoundscape) {
                    Text("Nature").tag("Nature")
                    Text("Electronic").tag("Electronic")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Breathing Pattern Selection
                Text("Select a Breathing Pattern:")
                    .font(.headline)
                    .padding(.top)
                
                Picker("Breathing Pattern", selection: $selectedBreathingPattern) {
                    Text("None").tag("None")
                    Text("Box Breathing").tag("Box Breathing")
                    Text("4-7-8 Breathing").tag("4-7-8 Breathing")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Breathing Sound (Overlay) Selection
                Text("Select a Breathing Sound:")
                    .font(.headline)
                    .padding(.top)
                
                Picker("Breathing Sound", selection: $selectedBreathingOverlay) {
                    Text("None").tag("None")
                    Text("Calm Chime").tag("Calm Chime") // Ensure you have CalmChime.mp3
                    Text("Ocean Waves").tag("Ocean Waves") // Ensure you have OceanWaves.mp3
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Navigate to Soundscape Detail View
                NavigationLink(destination: SoundscapeDetailView(
                                selectedSoundscape: selectedSoundscape,
                                selectedBreathingPattern: selectedBreathingPattern, // Use breathing pattern here
                                selectedBreathingOverlay: selectedBreathingOverlay)) {
                    Text("Play Soundscape")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("Soundscapes", displayMode: .inline)
        }
    }
}
