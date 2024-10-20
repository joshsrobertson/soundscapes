import SwiftUI
import Kingfisher
import AVFoundation

struct SoundscapeDetailView: View {
    @StateObject var soundscapeAudioManager = SoundscapeAudioManager()
    @StateObject var timerModel = TimerModel()
    @StateObject var breathingManager = BreathingManager()

    var selectedSoundscape: Soundscape // Use the Soundscape model
    var selectedBreathingPattern: BreathingPattern
    var selectedTime: Int
    var isJourneyMode: Bool
    var isBreathingMode: Bool
    var isSleepMode: Bool

    @State private var showPostSoundscapeView = false
    @State private var cycleStartTime: Int? = nil
    @State private var lastQuoteChangeTime: Int? = nil
    @State private var isQuoteVisible = false
    @State private var currentQuote: String = ""
    @State private var showBreathingCircle = false

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image loaded using Kingfisher
                KFImage(URL(string: selectedSoundscape.imageURL))
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Overlay for Sleep Mode or regular mode
                if isSleepMode {
                    Color.purple.opacity(0.6).edgesIgnoringSafeArea(.all)
                } else {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                }

                VStack {
                    Spacer() // Push the content down slightly to center it better

                    if isJourneyMode {
                        // Display quotes in Journey Mode
                        Text(currentQuote)
                            .font(.system(size: 19, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 10)
                            .shadow(radius: 10)
                            .frame(maxWidth: 300, minHeight: 300)

                        // Remaining Time Display in Journey Mode
                        Text("Remaining Time: \(formatTime(seconds: timerModel.remainingTime))")
                            .font(.custom("Avenir", size: 16))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                    } else if isBreathingMode {
                        if showBreathingCircle {
                            // Mute button and label for Breathing Metronome
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
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 40)
                            Spacer()
                                .frame(height: 50)

                            // Breathing Circle in Breathing Mode
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
                                    .font(.custom("Avenir", size: 18))
                                    .foregroundColor(.white)
                            }
                            .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)

                            Spacer()

                            // Remaining Time Display in Breath Mode
                            Text("Remaining Time: \(formatTime(seconds: timerModel.remainingTime))")
                                .font(.custom("Avenir", size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                .padding(.bottom, 20)
                        } else {
                            // "Get Ready to Breathe" message before the circle appears
                            Text("Take a deep breath in to begin.")
                                .font(.custom("Avenir", size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 60)
                                .multilineTextAlignment(.center)

                            Spacer()
                        }
                    } else if isSleepMode {
                        // Sleep Mode helper text
                        Text("Feel free to close your device, the audio will gently lower over time and fade out as you relax into sleep. Have a peaceful night.")
                            .font(.custom("Avenir", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 200)
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
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 170) // Adjust this to move the button higher
                }
            }
            .onAppear {
                            soundscapeAudioManager.playSoundscape(from: selectedSoundscape.audioURL)
                            soundscapeAudioManager.enableSleepMode(isSleepMode)
                            timerModel.startTimer(duration: selectedTime) {
                                showPostSoundscapeView = true
                            }
                            currentQuote = getRandomQuote(for: selectedSoundscape.id) // Use the getRandomQuote function with soundscape ID
                            isQuoteVisible = true

                            // Delay showing the breathing circle for 5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showBreathingCircle = true
                            }
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
                            soundscapeAudioManager.checkForFadeOut(remainingTime: timerModel.remainingTime)

                            // Update the quote every 20 seconds in Journey Mode
                            if isJourneyMode {
                                if lastQuoteChangeTime == nil {
                                    lastQuoteChangeTime = timerModel.remainingTime
                                } else if let lastChange = lastQuoteChangeTime,
                                          (lastChange - timerModel.remainingTime) >= 20 {
                                    isQuoteVisible = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                        currentQuote = getRandomQuote(for: selectedSoundscape.id) // Fetch new quote based on soundscape ID
                                        lastQuoteChangeTime = timerModel.remainingTime
                                        isQuoteVisible = true
                                    }
                                }
                            }
                        }
                        .onDisappear {
                            soundscapeAudioManager.stopAudio()
                        }
                        .navigationDestination(isPresented: $showPostSoundscapeView) {
                            PostSoundscapeView()
                        }
                    }
                }

                // Helper function to format time
                func formatTime(seconds: Int) -> String {
                    let minutes = seconds / 60
                    let seconds = seconds % 60
                    return String(format: "%02d:%02d", minutes, seconds)
                }
            }
