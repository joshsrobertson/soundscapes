import SwiftUI

struct TimerSelectionView: View {
    var selectedSoundscape: String
    var selectedBreathingPattern: BreathingPattern
    var backgroundImage: String
    @State private var selectedDuration: Int = 5 // Default to 5 minutes
    
    var body: some View {
        ZStack {
            // Full-bleed background image
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Journey Duration")
                    .font(.custom("Avenir", size: 28))
                    .foregroundColor(.white)

                // Timer Buttons
                VStack(spacing: 15) {
                    Button(action: { selectedDuration = 1 }) {
                        Text("1 Minute")
                            .frame(width: 200, height: 50)
                            .background(selectedDuration == 1 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { selectedDuration = 5 }) {
                        Text("5 Minutes")
                            .frame(width: 200, height: 50)
                            .background(selectedDuration == 5 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { selectedDuration = 10 }) {
                        Text("10 Minutes")
                            .frame(width: 200, height: 50)
                            .background(selectedDuration == 10 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { selectedDuration = 20 }) {
                        Text("20 Minutes")
                            .frame(width: 200, height: 50)
                            .background(selectedDuration == 20 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                // Navigation Link to start the session
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

                Spacer()
            }
            .padding()
        }
    }
}
