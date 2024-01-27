import SwiftUI

struct OnboardingView: View {
    @State private var isShowingSignupView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("Autoshopicon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .padding(.bottom, -10)

                    Text("歡迎進入AutoShop!")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()

                    NavigationLink(
                        destination: Signup(),
                        isActive: $isShowingSignupView,
                        label: {
                            EmptyView()
                        }
                    )
                }
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowingSignupView = true
                    }
                }

                VStack {
                    Spacer()
                    Image("eilogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .padding(.bottom, -20)

                    Text("All rights reserved by Everything Intelligence 2024")
                        .font(.footnote)
                        .foregroundColor(.black) // Set text color to black
                        .opacity(0.8)
                        .padding(.bottom, 0)
                }
            }
        }
    }
}
