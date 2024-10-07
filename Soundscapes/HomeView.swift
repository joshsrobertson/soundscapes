import SwiftUI

struct HomeView: View {
    @State private var selectedSoundscape: String = "Nature"
    @State private var selectedBreathingPattern: String = "None" // Default to no breathing pattern
    @State private var selectedTime: Int = 1 // Default to 1 minute
    let timerOptions = [1, 5, 10, 20, 60] // Options for timer in minutes

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

                // Timer Selection
                Text("Set Timer Duration:")
                    .font(.headline)
                    .padding(.top)
                
                Picker("Timer Duration", selection: $selectedTime) {
                    ForEach(timerOptions, id: \.self) { time in
                        Text("\(time) minutes").tag(time)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Navigate to Soundscape Detail View
                NavigationLink(destination: SoundscapeDetailView(
                                selectedSoundscape: selectedSoundscape,
                                selectedBreathingPattern: selectedBreathingPattern,
                                selectedTime: selectedTime)) {
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
