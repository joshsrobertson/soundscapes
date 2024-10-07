import SwiftUI

struct HomeView: View {
    @State private var selectedSoundscape: String = "Nature"
    @State private var selectedBreathingOverlay: String? = "None"

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

                // Breathing Overlay Selection
                Text("Select Breathing Overlay:")
                    .font(.headline)
                    .padding(.top)

                Picker("Breathing Overlay", selection: $selectedBreathingOverlay) {
                    Text("None").tag("None")
                    Text("Calm Chime").tag("CalmChime") // Ensure you have CalmChime.mp3
                    Text("Ocean Waves").tag("OceanWaves") // Ensure you have OceanWaves.mp3
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Navigate to Soundscape Detail View
                NavigationLink(destination: SoundscapeDetailView(
                                selectedSoundscape: selectedSoundscape,
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
