import SwiftUI

struct TimerSelectionView: View {
    var selectedSoundscape: String
    var selectedBreathingPattern: BreathingPattern
    @State private var selectedDuration: Int = 5

    var body: some View {
        VStack(spacing: 20) {
            Text("Selected Pattern: \(selectedBreathingPattern.name)")
                .font(.custom("Avenir", size: 28))
                .foregroundColor(.blue)

            Picker("Duration", selection: $selectedDuration) {
                Text("1 Minute").tag(1)
                Text("5 Minutes").tag(5)
                Text("10 Minutes").tag(10)
                Text("20 Minutes").tag(20)
                Text("1 Hour").tag(60)
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            NavigationLink(destination: SoundscapeDetailView(
                selectedSoundscape: selectedSoundscape,
                selectedBreathingPattern: selectedBreathingPattern.id,
                selectedTime: selectedDuration
            )) {
                Text("Start Session")
                    .font(.custom("Avenir", size: 22))
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 40)
        }
        .padding()
    }
}
