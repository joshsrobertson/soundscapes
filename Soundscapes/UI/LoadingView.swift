//
//  LoadingView.swift
//  Soundscapes
//
//  Created by Josh Robertson on 10/11/24.
//


import SwiftUI

struct LoadingView: View {
    @State private var isActive = false
    @State private var animationAmount = 1.0

    var body: some View {
        ZStack {
            // Background color or image
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                // App logo or loading animation
                Image("logo_200") // Replace with your app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(animationAmount)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            animationAmount = 1.2
                        }
                    }

                Text("Sound Journeys") // Customize your app's title
                    .font(.custom("Baskerville", size: 34)) // Avenir font for a sleek look
                    .foregroundColor(.black)
                    .padding(.top, 20)
                Text("Inspired by Nature.")
                    .font(.custom("Avenir", size: 20)) // Avenir for the description as well
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 5)
            }
        }
        .onAppear {
            // Wait for 3 seconds before navigating to the HomeView
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            // Show the HomeView after the loading screen
            HomeView()
        }
    }
}
