import SwiftUI
import Combine

struct BreathingPatternView: View {
    var pattern: String
    @Binding var remainingTime: Int // This binds to the timer in SoundscapeDetailView
    @State private var breathingPhase: String = "Inhale"
    @State private var circleScale: CGFloat = 0.8 // Set to smaller size initially for Inhale
    @State private var firstCycleComplete: Bool = false // Track whether the first cycle is complete
    
    var onPhaseChange: ((String) -> Void)? // Callback for phase change
    
    var body: some View {
        VStack {
            Text(firstCycleComplete ? "Phase: \(breathingPhase)" : "Follow the circle and sound with your breath and let yourself relax")
                .font(firstCycleComplete ? .title : .body) // Smaller text for first cycle
                .multilineTextAlignment(.center)
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
            updateBreathingPhase()
        })
        .onAppear {
            // Ensure the starting phase is Inhale with the circle in the smaller state
            breathingPhase = "Inhale"
            circleScale = 0.8 // Circle starts small on Inhale
            onPhaseChange?(breathingPhase) // Trigger overlay playback for initial phase
        }
    }
    
    func updateBreathingPhase() {
        // Change breathing phase depending on time left and pattern
        switch pattern {
        case "Box Breathing":
            let cycleLength = 16
            let cyclePosition = remainingTime % cycleLength
            
            if cyclePosition == 0 {
                firstCycleComplete = true // First cycle is complete after one full cycle
            }
            
            if cyclePosition < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if cyclePosition < 8 {
                breathingPhase = "Hold"
            } else if cyclePosition < 12 {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            } else {
                breathingPhase = "Hold"
            }
        case "4-7-8 Breathing":
            let cycleLength = 19
            let cyclePosition = remainingTime % cycleLength
            
            if cyclePosition == 0 {
                firstCycleComplete = true // First cycle is complete after one full cycle
            }
            
            if cyclePosition < 4 {
                breathingPhase = "Inhale"
                circleScale = 1.2 // Circle grows on Inhale
            } else if cyclePosition < 11 {
                breathingPhase = "Hold"
            } else {
                breathingPhase = "Exhale"
                circleScale = 0.8 // Circle shrinks on Exhale
            }
        default:
            breathingPhase = "Inhale"
            circleScale = 1.2 // Default size for Inhale
        }
        
        // Notify the parent view of phase change
        onPhaseChange?(breathingPhase)
    }
}
