import SwiftUI

struct CategorySelectionView: View {
    let categories = ["Nature", "Music", "Water", "Meditation", "Space"]
    let soundscapes: [Soundscape] // Pass all soundscapes here
    
    @State private var selectedCategory: String? = nil
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Select a Category")
                    .font(.custom("Baskerville", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.bottom, 10)
                }
                
                Spacer()
                
                // Proceed button only if a category is selected
                if let selectedCategory = selectedCategory {
                    NavigationLink(
                        destination: SoundscapeSelectionView(
                            isBreathingMode: false, // Adjust based on where this is coming from
                            isSleepMode: false,
                            filteredSoundscapes: soundscapes.filter { $0.tags.contains(selectedCategory) }
                        )
                    ) {
                        Text("Continue")
                            .font(.custom("Avenir", size: 18))
                            .padding()
                            .frame(width: 200)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
