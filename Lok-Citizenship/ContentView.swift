import SwiftUI

struct ContentView: View {
    var body: some View {
    
        VStack {
            Spacer()
            Text("Welcome, Your Citizenship Journey Begins!")
                .padding()
                .padding()
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
//                .overlay(
//                     Text("Welcome, Your Citizenship Journey Begins!")
//                         .font(.title)
//                         .multilineTextAlignment(.center)
//                         .foregroundColor(.white)
//                         .shadow(color: .white, radius: 10)
//                 )
            
            Spacer()

            Text("Practice Multiple Choice Questions and Build Your Confidence for the Citizenship Interview...")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            Spacer()
            
            NavigationLink(destination: PracticeSelection()) {
                Text("Let's Begin 📖")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.8)
            )
        )
    }
    
}
