import SwiftUI

struct SoundscapeDetailView: View {
    @StateObject var soundscapeAudioManager = SoundscapeAudioManager()
    @StateObject var timerModel = TimerModel()
    @StateObject var breathingManager = BreathingManager()

    var selectedSoundscape: String
    var selectedBreathingPattern: BreathingPattern
    var selectedTime: Int
    
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
                if selectedBreathingPattern.id == "None" {
                                   Text(currentQuote)
                                       .font(.system(size: 19, weight: .medium, design: .rounded))
                                       .foregroundColor(.white)
                                       .multilineTextAlignment(.center)
                                       .padding(.horizontal, 30)
                                       .padding(.vertical, 10)
                                       .background(Color.gray.opacity(0.2))
                                       .cornerRadius(10)
                                       .shadow(radius: 10)
                                       .frame(maxWidth: 300, maxHeight: .infinity, alignment: .center)
                                       //.opacity(isQuoteVisible ? 1 : 0) // Apply fade-in animation
                                       //.animation(.easeInOut(duration: 1), value: isQuoteVisible)
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

                    Spacer()
                }

                // Stop button
                Button(action: {
                    soundscapeAudioManager.stopAudio()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Stop")
                        .font(.body)
                        .padding()
                        .frame(width: 150)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // Remaining Time Display
                Text("Remaining Time: \(formatTime(seconds: timerModel.remainingTime))")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

            }
        }
        .onAppear {
                    soundscapeAudioManager.setupAudioEngine()
                    soundscapeAudioManager.playSoundscape(soundscape: selectedSoundscape)
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

                    // Update the quote every 20 seconds
                                if lastQuoteChangeTime == nil {
                                    lastQuoteChangeTime = timerModel.remainingTime
                                } else if let lastChange = lastQuoteChangeTime,
                                          (lastChange - timerModel.remainingTime) >= 20 {
                                    // Change the quote every 20 seconds
                                    isQuoteVisible = false // Fade out the current quote first
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                        currentQuote = getRandomQuote(for: selectedSoundscape)
                                        lastQuoteChangeTime = timerModel.remainingTime
                                        isQuoteVisible = true // Fade-in the new quote
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
