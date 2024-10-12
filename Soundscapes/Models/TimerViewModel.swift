import Foundation
class TimerModel: ObservableObject {
    @Published var remainingTime: Int = 300 // Default to 60 seconds
    private var timer: Timer?
    
    func startTimer(duration: Int, onFinish: @escaping () -> Void) {
        remainingTime = duration * 60 // Convert minutes to seconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
                onFinish()
            }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
