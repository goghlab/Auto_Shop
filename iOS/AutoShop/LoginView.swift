import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var navigateToQRCodeView = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image("Autoshopicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .offset(y: 0)

                    Text("用戶登入")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 30)

                    VStack(spacing: 15) {
                        TextField("輸入電郵", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                            .foregroundColor(.black)
                            .font(.body)
                            .autocapitalization(.none)

                        SecureField("輸入密碼", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                            .foregroundColor(.black)
                            .font(.body)
                            .autocapitalization(.none)
                    }

                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)

                    Button("立即登入") {
                        if isValidInput() {
                            authenticateUser()
                        } else {
                            errorMessage = "輸入無效。請檢查您的資訊。"
                        }
                    }
                    .buttonStyle(SharedButtonStyle())  // Using the shared button style
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)

                    NavigationLink(destination: MyqrcodeView(uid: getUserId()), isActive: $navigateToQRCodeView) {
                        EmptyView()
                    }
                    .isDetailLink(false)

                    HStack {
                        Text("還沒有帳戶？")

                        NavigationLink("立即註冊", destination: Signup())
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 0)
                }
                .padding()
                .offset(y: -30)
            }
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
                errorMessage = "錯誤：\(error.localizedDescription)"
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
