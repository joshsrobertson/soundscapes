import SwiftUI

struct PostSoundscapeView: View {
    @State private var isTextVisible = false // For fade-in animation
    @State private var navigateToHome = false // For NavigationLink

    var body: some View {
        ZStack {
            // Background image (AutumnFall)
            Image("AutumnWind")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                // Circular background with fade-in text
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 400, height: 400)
                        .shadow(radius: 10)
                    
                    Text("Hope you had a great session. Have a peaceful day or night.")
                        .font(.custom("Avenir", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(isTextVisible ? 1 : 0) // Text fades in
                        .animation(.easeInOut(duration: 2), value: isTextVisible)
                }
                
                Spacer()
                
                // Return to Home button with NavigationLink
                Button(action: {
                    // Trigger navigation to HomeView
                    navigateToHome = true
                }) {
                    NavigationLink(
                        destination: HomeView().navigationBarBackButtonHidden(true)) {
                        Text("Return to Home")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(width: 150)
                                .padding(10)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                    }
                }
                Spacer()
                Spacer()
            }
            .navigationBarBackButtonHidden(true) // Hide back button on this view
            .padding(.horizontal, 20)
            .onAppear {
                withAnimation {
                    isTextVisible = true
                }
            }
        }
    }
}
