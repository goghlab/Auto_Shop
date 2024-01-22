import SwiftUI

struct ContentView: View {
    @State private var isShowingOnboarding = false

    var body: some View {
        ZStack {
            Image("bkbg") // Replace "bkbg" with your actual background image asset name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("EVERYTHING INTELLIGENCE.")
                    .font(.system(size: 24)) // Adjust the size as needed
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("AutoShop")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the entire screen
            .padding() // Add some padding to the VStack

        }
        .onAppear {
            // Use a delay to wait for two seconds (adjust as needed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Switch to the onboarding page
                isShowingOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            // Replace OnboardingView with the actual name of your onboarding view
            OnboardingView()
        }
    }
}
