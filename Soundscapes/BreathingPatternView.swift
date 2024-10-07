import SwiftUI
import Combine

struct BreathingPatternView: View {
    var pattern: String
    @Binding var remainingTime: Int // This binds to the timer in SoundscapeDetailView
    @State private var breathingPhase: String = "Inhale"
    @State private var circleScale: CGFloat = 0.8 // Set to smaller size initially for Inhale
    @State private var cycleStartTime: Int = 0 // Track when the current cycle starts
    
    var body: some View {
        VStack {
            Text("\(breathingPhase)")
                .font(.title)
                .padding()
            
            // Breathing circle that grows and shrinks based on phase
            Circle()
                .scaleEffect(circleScale) // Use variable for scale
                .frame(width: 150, height: 150)
                .animation(.easeInOut(duration: 4), value: circleScale)
                .padding()
            
            Spacer()
        }
        .onChange(of: remainingTime, perform: { _ in
            if cycleStartTime == 0 {
                cycleStartTime = remainingTime // Record the initial time when the breathing starts
            }
            updateBreathingPhase()
        })
        .onAppear {
            breathingPhase = "Inhale"
            circleScale = 0.8 // Circle starts small on Inhale
            cycleStartTime = remainingTime // Set the start time on view appearance
        }
    }
    
    func updateBreathingPhase() {
        // Adjust the breathing pattern depending on the phase and time elapsed
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
