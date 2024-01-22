import SwiftUI

struct OnboardingView: View {
    @State private var isShowingSignupView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg1") // Replace "bg1" with your actual background image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("eilogo") // Replace "eilogo" with your actual image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .padding(.bottom, -50)

                    Text("Welcome to AutoShop!")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.system(size: 10)) // Adjust the size as needed

                    NavigationLink(
                        destination: Signup(),
                        isActive: $isShowingSignupView,
                        label: {
                            Button("Get Started") {
                                // Add any actions you want when the "Get Started" button is tapped
                                isShowingSignupView = true
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    )
                }
                .padding()
                .onAppear {
                    // Use a delay to wait for two seconds (adjust as needed)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Switch to the signup page
                        isShowingSignupView = true
                    }
                }
            }
        }
    }
}
