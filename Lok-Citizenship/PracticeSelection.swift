import SwiftUI

struct PracticeSelection: View {
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                Text("Choose Your Practice Below (English) 👇🏻")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                practiceButton(title: "Practice 1: Easy Questions", destination: Practice1(), minHeight: 20, fontSize: 16)
                practiceButton(title: "Practice 2: Easy Questions", destination: Practice2(), minHeight: 25, fontSize: 18)
                practiceButton(title: "Practice 3: Medium Questions", destination: Practice3(), minHeight: 30, fontSize: 20)
                practiceButton(title: "Practice 4: Hard Questions", destination: Practice4(), minHeight: 35, fontSize: 22)
                practiceButton(title: "Practice 5: Hardest Questions", destination: Practice5(), minHeight: 40, fontSize: 24)

                Text("आफ्नो अभ्यास छान्नुहोस् (English & नेपाली) 👇🏻")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                practiceButton(title: "पहिलो अभ्यास: सजिलो प्रश्नहरू", destination: अभ्यास1(), minHeight: 20, fontSize: 16)
                practiceButton(title: "दोस्रो अभ्यास: सजिलो प्रश्नहरू", destination: अभ्यास2(), minHeight: 25, fontSize: 18)
                practiceButton(title: "तेस्रो अभ्यास: मध्यम प्रश्नहरू", destination: अभ्यास3(), minHeight: 30, fontSize: 20)
                practiceButton(title: "चौथो अभ्यास: कठिन प्रश्नहरू", destination: अभ्यास4(), minHeight: 35, fontSize: 22)
                practiceButton(title: "पाँचौं अभ्यास: सबैभन्दा कठिन प्रश्नहरू", destination: अभ्यास5(), minHeight: 40, fontSize: 24)

                Spacer()
                    .frame(height: 50)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Practice Selection")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.8))
        )
    }
    
    @ViewBuilder
    private func practiceButton<Destination: View>(title: String, destination: Destination, minHeight: CGFloat, fontSize: CGFloat) -> some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold)) // ✅ Dynamic font size
                .frame(maxWidth: .infinity, minHeight: minHeight) // ✅ Button height grows
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
        }
    }
}
