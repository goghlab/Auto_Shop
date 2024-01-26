import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var navigateToQRCodeView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("客戶登入") // Customer Login in traditional Chinese
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .foregroundColor(.blue)

                TextField("輸入電郵", text: $email) // Enter Email in traditional Chinese
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                SecureField("輸入密碼", text: $password) // Enter Password in traditional Chinese
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)

                Button("用戶登入") { // Login in traditional Chinese
                    if isValidInput() {
                        authenticateUser()
                    } else {
                        errorMessage = "輸入無效。請檢查您的資訊。" // Invalid input. Please check your information. in traditional Chinese
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)

                NavigationLink(destination: MyqrcodeView(uid: getUserId()), isActive: $navigateToQRCodeView) {
                    EmptyView()
                }
                .isDetailLink(false)

                HStack {
                    Text("還沒有帳戶？") // Don't have an account? in traditional Chinese

                    NavigationLink("立即註冊", destination: Signup()) // Sign Up in traditional Chinese
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }

    private func isValidInput() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }

    private func getUserId() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return ""
    }

    private func authenticateUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "錯誤：\(error.localizedDescription)" // Error: ... in traditional Chinese
            } else {
                navigateToQRCodeView = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
