import SwiftUI

struct SoundscapeDetailView: View {
    @StateObject var soundscapeAudioManager = SoundscapeAudioManager()
    @StateObject var timerModel = TimerModel()
    @StateObject var breathingManager = BreathingManager()

    var selectedSoundscape: String
    var selectedBreathingPattern: BreathingPattern
    var selectedTime: Int
    var isSleepMode: Bool // New flag for Sleep Mode

    @State private var showPostSoundscapeView = false
    @State private var cycleStartTime: Int? = nil
    @State private var lastQuoteChangeTime: Int? = nil
    @State private var isQuoteVisible = false
    @State private var currentQuote: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background image
            Image(selectedSoundscape)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Purple-blue overlay with 60% opacity in Sleep Mode
            if isSleepMode {
                Color.purple.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
            } else {
                // Black overlay with 30% opacity in non-Sleep Mode
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack(spacing: 40) {
                // Mute button and label
                if selectedBreathingPattern.id != "None" {
                    HStack(spacing: 10) {
                        Button(action: {
                            breathingManager.toggleMute()
                        }) {
                            Image(systemName: breathingManager.isMuted ? "speaker.slash.fill" : "speaker.3.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        Text("Breath Metronome")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical, 50)
                    }
                }

                // In Sleep Mode, hide quotes and remaining time
                if !isSleepMode {
                    // Display quote in non-Sleep Mode
                    if selectedBreathingPattern.id == "None" {
                        Text(currentQuote)
                            .font(.system(size: 19, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 10)
                            .shadow(radius: 10)
                            .frame(maxWidth: 300, minHeight: 300)
                    } else {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.5)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 250, height: 250)
                                .scaleEffect(breathingManager.circleScale)
                                .animation(.easeInOut(duration: 4), value: breathingManager.circleScale)

                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 150, height: 150)
                                .scaleEffect(breathingManager.circleScale)
                                .animation(.easeInOut(duration: 4), value: breathingManager.circleScale)

                            Text(breathingManager.breathingPhase)
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        
                      
                    }

                    // Remaining Time Display (only in non-Sleep Mode)
                    Text("Remaining Time: \(formatTime(seconds: timerModel.remainingTime))")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .padding(.top, 40)
                }

                // "Feel free to close your device" text helper in Sleep Mode above the Stop button
                if isSleepMode {
                    Text("Feel free to close your device, the audio will gently lower over time and fade out as you relax into sleep. Have a peaceful night.")
                        .font(.custom("Avenir", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                        .padding(.top, 100)
                }

                // Stop button
                Button(action: {
                    soundscapeAudioManager.stopAudio()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Stop")
                        .font(.custom("Avenir", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 150)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

            }
        }
        .onAppear {
            soundscapeAudioManager.setupAudioEngine()
            soundscapeAudioManager.playSoundscape(soundscape: selectedSoundscape)
            soundscapeAudioManager.enableSleepMode(isSleepMode)
            timerModel.startTimer(duration: selectedTime) {
                showPostSoundscapeView = true
            }
            currentQuote = getRandomQuote(for: selectedSoundscape)
            isQuoteVisible = true
        }
        .onChange(of: timerModel.remainingTime) { _ in
            if cycleStartTime == nil {
                cycleStartTime = timerModel.remainingTime
            }
            breathingManager.updateBreathingPhase(
                selectedBreathingPattern: selectedBreathingPattern,
                remainingTime: timerModel.remainingTime,
                cycleStartTime: cycleStartTime
            )

            // Let the sound manager handle the fade-out
            soundscapeAudioManager.checkForFadeOut(remainingTime: timerModel.remainingTime)

            // Update the quote every 20 seconds in non-Sleep Mode
            if !isSleepMode {
                if lastQuoteChangeTime == nil {
                    lastQuoteChangeTime = timerModel.remainingTime
                } else if let lastChange = lastQuoteChangeTime,
                          (lastChange - timerModel.remainingTime) >= 15 {
                    // Change the quote every 20 seconds
                    isQuoteVisible = false // Fade out the current quote first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        currentQuote = getRandomQuote(for: selectedSoundscape)
                        lastQuoteChangeTime = timerModel.remainingTime
                        isQuoteVisible = true // Fade-in the new quote
                    }
                }
            }
        }
        .onDisappear {
            soundscapeAudioManager.stopAudio()
        }
        NavigationLink(destination: PostSoundscapeView(), isActive: $showPostSoundscapeView) {
            EmptyView()
        }
    }

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
