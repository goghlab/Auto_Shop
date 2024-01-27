import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Signup: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var uid: String?
    @State private var navigateToQRCodeView = false
    @State private var navigateToLoginView = false // State variable for navigation to login view

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

                    Text("用戶登記")
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

                    Button(action: {
                        if isValidInput() {
                            signUpWithFirebase()
                        } else {
                            errorMessage = "Invalid input. Please check your information."
                        }
                    }) {
                        Text("立即登記")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.vertical, 0) // Adjust vertical padding here
                    }
                    .buttonStyle(SharedButtonStyle())
                    .frame(maxWidth: .infinity)

                    HStack {
                        Text("註冊即表示您同意我們的")

                        NavigationLink(destination: MyqrcodeView(uid: uid ?? ""), isActive: $navigateToQRCodeView) {
                            EmptyView()
                        }
                        .isDetailLink(false)

                        // Use a Link for the Privacy Policy
                        Link("隱私政策", destination: URL(string: "https://www.everything-intelligence.com/privacy/")!)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)

                    // Text link for login
                    Text("已有戶口？立即登入")
                        .foregroundColor(.blue)
                        .underline()
                        .onTapGesture {
                            navigateToLoginView = true // Set the state variable to trigger navigation
                        }
                        .padding(.top, 10)
                }
                .padding()
            }
            .background(NavigationLink("", destination: LoginView(), isActive: $navigateToLoginView))
            // Use an invisible NavigationLink as a workaround for immediate navigation
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
                if let uid = authResult?.user.uid {
                    createFirestoreUser(uid: uid)
                    self.uid = uid
                    navigateToQRCodeView = true
                }
            }
        }
    }

    private func createFirestoreUser(uid: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")

        let userData: [String: Any] = [
            "email": email,
            "uid": uid,
            // Add other user-related data
        ]

        usersCollection.document(uid).setData(userData) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                print("User document created successfully")
            }
        }
    }
}

