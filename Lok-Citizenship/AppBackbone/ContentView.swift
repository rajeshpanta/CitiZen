import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                Text("Welcome!\nYour Citizenship Journey Begins")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Spacer()

                NavigationLink("Let's Begin 📖") {
                    LanguageSelectionView()
                }
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 220)
                .background(Color.blue)
                .cornerRadius(12)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("BackgroundImage")
                    .resizable().scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.8))
            )
        }
    }
}
