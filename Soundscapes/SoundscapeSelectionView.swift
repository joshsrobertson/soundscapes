import SwiftUI

struct SoundscapeSelectionView: View {
    @Binding var selectedSoundscape: String
    @Binding var selectedBreathingOverlay: String?

    var body: some View {
        VStack {
            Text("Select a Soundscape")
                .font(.headline)
                .padding()

            Picker("Soundscapes", selection: $selectedSoundscape) {
                Text("Nature").tag("Nature")
                Text("Electronic").tag("Electronic")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Text("Select Breathing Overlay")
                .font(.headline)
                .padding(.top)

            Picker("Breathing Overlay", selection: $selectedBreathingOverlay) {
                Text("None").tag("None")
                Text("Calm Chime").tag("CalmChime")
                Text("Nature Sounds").tag("NatureSounds")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }
}
