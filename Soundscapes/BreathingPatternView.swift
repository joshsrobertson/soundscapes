import SwiftUI
import Combine

struct BreathingPatternView: View {
    var pattern: String
    @Binding var remainingTime: Int // This binds to the timer in SoundscapeDetailView
    @State private var breathingPhase: String = "Inhale"
    @State private var circleScale: CGFloat = 0.8 // Set to smaller size initially for Inhale
    @State private var cycleStartTime: Int? = nil // Track when the current cycle starts
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Breathing Phase Text
                Text(breathingPhase)
                    .font(.system(size: 36, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.5))
                    )
                    .padding(.top, 50)
                
                // Breathing circle that grows and shrinks based on phase
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
                        .scaleEffect(circleScale)
                        .animation(.easeInOut(duration: 4), value: circleScale)

                    // Inner Circle
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 150, height: 150)
                        .scaleEffect(circleScale)
                        .animation(.easeInOut(duration: 4), value: circleScale)
                }
                .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)

                Spacer()
            }
        }
        .onAppear {
            breathingPhase = "Inhale"
            circleScale = 0.8 // Circle starts small on Inhale
            cycleStartTime = remainingTime // Set the start time on view appearance
        }
        .onChange(of: remainingTime) { _ in
            if cycleStartTime == nil {
                cycleStartTime = remainingTime // Record the initial time when the breathing starts
            }
            updateBreathingPhase()
        }
    }
    
    func updateBreathingPhase() {
        // Adjust the breathing pattern depending on the phase and time elapsed
        guard let cycleStartTime = cycleStartTime else { return }
        let timeElapsed = cycleStartTime - remainingTime
        
        switch pattern {
        case "Box Breathing":
            let cycleLength = 16
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if phaseTime < 8 {
                breathingPhase = "Hold"
                circleScale = 1.2 // Circle stays the same size during Hold
            } else if phaseTime < 12 {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            } else {
                breathingPhase = "Hold"
                circleScale = 0.8 // Circle stays small during Hold
            }
        case "4-7-8 Breathing":
            let cycleLength = 19
            let phaseTime = timeElapsed % cycleLength
            
            if phaseTime < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if phaseTime < 11 {
                breathingPhase = "Hold"
                circleScale = 1.2 // Circle stays the same size during Hold
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            }
        default:
            breathingPhase = "Inhale"
            circleScale = 1.2 // Default size for Inhale
        }
    }
}
// comment
