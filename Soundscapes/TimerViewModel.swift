//
//  TimerViewModel.swift
//  Soundscapes
//
//  Created by Josh Robertson on 10/4/24.
//

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

    // Start a timer based on the selected breathing pattern
    func startBreathingPattern(pattern: String) {
        switch pattern {
        case "Box Breathing":
            startTimer(for: 60)  // Set a total duration for Box Breathing (example: 60 seconds)
        case "4-7-8 Breathing":
            startTimer(for: 90)  // Set a total duration for 4-7-8 Breathing (example: 90 seconds)
        default:
            startTimer(for: 60)  // Default to 60 seconds if pattern is unrecognized
        }
    }
}
