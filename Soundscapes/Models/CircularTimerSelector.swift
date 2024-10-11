import SwiftUI
import CoreHaptics

struct CircularTimerSelector: View {
    @Binding var selectedDuration: Int
    @State private var angle: Double = -.pi / 2 // Start at the top (12 o'clock)
    @State private var isDragging = false
    @State private var knobPosition: CGPoint = CGPoint(x: 0, y: -125)
    @Binding var hapticEngine: CHHapticEngine? // For haptic feedback

    let minTime = 1
    let maxTime = 60
    let radius: CGFloat = 125

    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 15)
                .frame(width: radius * 2, height: radius * 2)
                .rotationEffect(.degrees(90)) // Rotate to start at top

            // Time label
            Text("\(selectedDuration) min")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Knob for user to drag
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 30)
                .shadow(radius: 5)
                .position(knobPosition)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            handleDragChange(location: value.location)
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )
        }
        .frame(width: radius * 2, height: radius * 2)
        .onAppear {
            updateKnobPosition()
        }
    }

    private func handleDragChange(location: CGPoint) {
        let center = CGPoint(x: radius, y: radius)
        let vector = CGVector(dx: location.x - center.x, dy: location.y - center.y)
        var dragAngle = atan2(vector.dy, vector.dx)

        // Ensure the angle stays in the range [0, 2π]
        if dragAngle < -.pi / 2 {
            dragAngle += 2 * .pi
        }
        
        // Update the angle and selected duration based on the drag position
        withAnimation {
            angle = dragAngle
            updateKnobPosition()
        }

        // Convert angle to time, keeping the range from 1 to 60 minutes
        let percentage = (angle + .pi / 2) / (2 * .pi)
        let newTime = Int(percentage * Double(maxTime - minTime)) + minTime
        let clampedTime = min(max(newTime, minTime), maxTime)

        if clampedTime != selectedDuration {
            selectedDuration = clampedTime
            triggerHapticFeedback() // Trigger haptic feedback when the duration changes
        }
    }

    private func updateKnobPosition() {
        let xOffset = radius * cos(angle)
        let yOffset = radius * sin(angle)
        knobPosition = CGPoint(x: radius + xOffset, y: radius + yOffset)
    }

    private func triggerHapticFeedback() {
        guard let engine = hapticEngine else { return }

        let hapticEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
}
