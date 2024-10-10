import SwiftUI

struct TimerSelectionView: View {
    var selectedSoundscape: String
    var selectedBreathingPattern: BreathingPattern
    var backgroundImage: String
    var isSleepMode: Bool // New flag for Sleep Mode
    
    @State private var selectedDuration: Int = 5 // Default to 5 minutes
    
    var body: some View {
        ZStack {
            // Full-bleed background image
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    // A semi-transparent overlay to make the text stand out
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                )

            VStack(spacing: 20) {
                Text("Journey Length")
                    .font(.custom("Baskerville", size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // Timer Buttons
                VStack(spacing: 20) {
                    if isSleepMode {
                        // Only show these options in Sleep Mode
                        timerButton(duration: 10, label: "10 Minutes")
                        timerButton(duration: 20, label: "20 Minutes")
                        timerButton(duration: 60, label: "1 Hour")
                    } else {
                        // Default options for other modes
                        timerButton(duration: 1, label: "1 Minute")
                        timerButton(duration: 5, label: "5 Minutes")
                        timerButton(duration: 10, label: "10 Minutes")
                        timerButton(duration: 20, label: "20 Minutes")
                        timerButton(duration: 60, label: "1 Hour")
                    }
                }

                // Sleep Mode text
                if isSleepMode {
                    Text("The soundscape will gradually start fading out after 5 minutes to half volume until the end of the journey.")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
                
                // Navigation Link to start the session
                NavigationLink(destination: SoundscapeDetailView(
                    selectedSoundscape: selectedSoundscape,
                    selectedBreathingPattern: selectedBreathingPattern, // Correct object passed here
                    selectedTime: selectedDuration,
                    isSleepMode: isSleepMode // Ensure the Sleep Mode flag is passed here
                )) {
                    Text("Start Session")
                        .font(.custom("Avenir", size: 22))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 220)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 40)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 50) // Add bottom padding for spacing
        }
    }
    
    // Helper function to generate buttons dynamically
    @ViewBuilder
    func timerButton(duration: Int, label: String) -> some View {
        Button(action: {
            selectedDuration = duration
        }) {
            Text(label)
                .font(.custom("Avenir", size: 20))
                .fontWeight(.medium)
                .frame(width: 200, height: 50)
                .background(LinearGradient(
                    gradient: Gradient(colors: selectedDuration == duration ? [Color.blue, Color.green] : [Color.gray.opacity(0.8), Color.gray]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: selectedDuration == duration ? Color.green.opacity(0.5) : Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}
