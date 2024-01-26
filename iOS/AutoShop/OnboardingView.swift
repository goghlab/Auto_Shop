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
                        .frame(width: 220, height: 220)
                        .padding(.bottom, -90)

                    Text("歡迎進入AutoShop!")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()


                    NavigationLink(
                        destination: Signup(),
                        isActive: $isShowingSignupView,
                        label: {
                            Button("進入商店") {
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
