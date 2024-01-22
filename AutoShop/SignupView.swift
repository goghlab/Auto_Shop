import SwiftUI
import FirebaseAuth

struct Signup: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isShowingMyQRCode = false // Updated state for navigation

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .foregroundColor(.blue)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)

            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 10)

            Button("Sign Up") {
                // Implement signup logic here
                if isValidInput() {
                    signUpWithFirebase()
                } else {
                    errorMessage = "Invalid input. Please check your information."
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            HStack {
                Text("By signing up, you agree to our")

                Link("Privacy Policy", destination: URL(string: "https://www.everything-intelligence.com/privacy/")!)
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $isShowingMyQRCode) {
            MyqrcodeView() // Update with the actual destination view
        }
    }

    private func isValidInput() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }

    private func signUpWithFirebase() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else {
                // User signed up successfully, navigate to MyQRCode
                isShowingMyQRCode = true
            }
        }
    }
}
