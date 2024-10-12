import SwiftUI

struct PostSoundscapeView: View {
    @State private var isTextVisible = false // For fade-in animation
    @State private var navigateToHome = false // For NavigationLink

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
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
                        .font(.custom("Avenir", size: 22))
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
                            .font(.custom("Avenir", size: 22))
                            .padding()
                            .frame(width: 250)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
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
