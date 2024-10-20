import SwiftUI
import CoreHaptics
import Kingfisher

struct TimerSelectionView: View {
    var selectedSoundscape: Soundscape
    var selectedBreathingPattern: BreathingPattern
    var backgroundImage: String
    var isSleepMode: Bool
    var isJourneyMode: Bool
    var isBreathingMode: Bool
    
    @State private var selectedDuration: Int = 5
    @State private var hapticEngine: CHHapticEngine? // For haptic feedback
    @State private var backgroundImageURL: String = "" // URL for the background image from S3

    var body: some View {
        ZStack {
            // Full-bleed background image using Kingfisher for S3
            KFImage(URL(string: selectedSoundscape.imageURL))
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                )

            VStack(spacing: 30) {
                Text("Journey Length")
                    .font(.custom("Baskerville", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                    .padding(.top, 120)
                    .padding(.bottom, 20)

                // Circular Timer Selector
                CircularTimerSelector(selectedDuration: $selectedDuration, hapticEngine: $hapticEngine)

                // Quick selection buttons (change based on isSleepMode)
                HStack(spacing: 20) {
                    if isSleepMode {
                        quickSelectButton(duration: 5)
                        quickSelectButton(duration: 10)
                        quickSelectButton(duration: 30)
                        quickSelectButton(duration: 60)
                    } else {
                        quickSelectButton(duration: 1)
                        quickSelectButton(duration: 5)
                        quickSelectButton(duration: 10)
                        quickSelectButton(duration: 20)
                    }
                }
                .padding(.top, 30)
                
                // Navigation Link to start the session
                NavigationLink(destination: SoundscapeDetailView(
                    soundscapeAudioManager: SoundscapeAudioManager(),
                    timerModel: TimerModel(),
                    breathingManager: BreathingManager(),
                    selectedSoundscape: selectedSoundscape,
                    selectedBreathingPattern: selectedBreathingPattern,
                    selectedTime: selectedDuration,
                    isJourneyMode: isJourneyMode,
                    isBreathingMode: isBreathingMode,
                    isSleepMode: isSleepMode
                )) {
                    Text("Start Session")
                        .font(.custom("Avenir", size: 16))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 40)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
            .onAppear {
                prepareHaptics()
                // Set the background image URL from S3
                backgroundImageURL = "https://soundjourneys-hosted-content.s3.us-east-2.amazonaws.com/BG+Images/\(backgroundImage).jpg"
            }
        }
    }

    func prepareHaptics() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic engine failed to start: \(error.localizedDescription)")
        }
    }
    
    // Quick select button function
    @ViewBuilder
    func quickSelectButton(duration: Int) -> some View {
        Button(action: {
            selectedDuration = duration
        }) {
            Text("\(duration) ")
                .font(.custom("Avenir", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(width: 60)
                .background(selectedDuration == duration ? Color.blue : Color.black.opacity(0.5))
                .cornerRadius(8)
                .shadow(radius: 5)
        }
    }
}
