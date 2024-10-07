import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var secondsLeft: Int = 0
    private var cancellable: AnyCancellable?
    
    // Start a general timer (e.g., for soundscapes or any duration)
    func startTimer(for duration: Int) {
        secondsLeft = duration
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.secondsLeft ?? 0 > 0 {
                    self?.secondsLeft -= 1
                } else {
                    self?.cancellable?.cancel()
                }
            }
    }

    // Stop the timer
    func stopTimer() {
        cancellable?.cancel()
    }
}
