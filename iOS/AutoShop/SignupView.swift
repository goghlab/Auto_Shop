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
            VStack {
                ZStack {
                    Text("客戶登記")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 20)

                TextField("輸入電郵", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                SecureField("輸入密碼", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)

                Button("立即登記") {
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
                    Text("註冊即表示您同意我們的")

                    NavigationLink(destination: MyqrcodeView(uid: uid ?? ""), isActive: $navigateToQRCodeView) {
                        EmptyView()
                    }
                    .isDetailLink(false)

                    Button("隱私政策") {
                        navigateToQRCodeView = true
                    }
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
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
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
