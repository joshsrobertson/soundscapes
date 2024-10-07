//
//  BreathingPatternView.swift
//  Soundscapes
//
//  Created by Josh Robertson on 10/4/24.
//

import SwiftUI
import Combine

struct BreathingPatternView: View {
    var pattern: String
    
    @State private var breathingPhase: String = "Inhale"
    @StateObject private var timerVM = TimerViewModel()
    
    var body: some View {
        VStack {
            Text("\(pattern)")
                .font(.title)
                .padding()
            
            // Visual cue for breathing (e.g., expanding/contracting circle)
            Circle()
                .scaleEffect(breathingPhase == "Inhale" ? 1.2 : 0.8)
                .frame(width: 150, height: 150)
                .animation(.easeInOut(duration: 4), value: breathingPhase)
                .padding()
            
            Text("Phase: \(breathingPhase)")
                .font(.headline)
                .padding()
            
            // Start the breathing exercise
            Button(action: {
                startBreathingExercise()
            }) {
                Text("Start Breathing Exercise")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .onReceive(timerVM.$secondsLeft, perform: { timeLeft in
            updateBreathingPhase()
        })
    }
    
    func startBreathingExercise() {
        timerVM.startBreathingPattern(pattern: pattern)
    }
    
    func updateBreathingPhase() {
        // Change breathing phase depending on time left and pattern
        switch pattern {
        case "Box Breathing":
            if timerVM.secondsLeft % 16 < 4 { breathingPhase = "Inhale" }
            else if timerVM.secondsLeft % 16 < 8 { breathingPhase = "Hold" }
            else if timerVM.secondsLeft % 16 < 12 { breathingPhase = "Exhale" }
            else { breathingPhase = "Hold" }
        case "4-7-8 Breathing":
            if timerVM.secondsLeft % 19 < 4 { breathingPhase = "Inhale" }
            else if timerVM.secondsLeft % 19 < 11 { breathingPhase = "Hold" }
            else { breathingPhase = "Exhale" }
        default:
            breathingPhase = "Inhale"
        }
        
        // Trigger sound cues based on phase (e.g., natural sounds or chimes)
        playBreathingSoundCues(phase: breathingPhase)
    }
    
    func playBreathingSoundCues(phase: String) {
        // Logic for playing sound cues (natural sounds or chimes) goes here
    }
}
