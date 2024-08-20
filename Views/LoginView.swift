import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String?
    @State private var userRole: String = ""
    @State private var userId: Int = 0
    private let authService = AuthService()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Login") {
                    authService.login(username: username, password: password) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let user):
                                print("Logged in user: \(user)")
                                self.userRole = user.role
                                self.userId = user.id
                                self.isLoggedIn = true
                            case .failure(let error):
                                self.loginError = error.localizedDescription
                                print("Login failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(
                    destination: FlightListView(userRole: userRole, userId: userId),
                    isActive: $isLoggedIn
                ) {
                    EmptyView()
                }

                Spacer()

                Button("Go Back") {
                    navigateToWelcome()
                }
                .padding()
                .foregroundColor(.blue)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    private func navigateToWelcome() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: WelcomeView())
            window.makeKeyAndVisible()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
