import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String?
    private let authService = AuthService()

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(TextFieldModifiers())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(TextFieldModifiers())

            Button("Login") {
                authService.login(username: username, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(true):
                            isLoggedIn = true
                            loginError = nil
                        case .success(false):
                            loginError = "Invalid username or password"
                            isLoggedIn = false
                        case .failure(let error):
                            loginError = error.localizedDescription
                            isLoggedIn = false
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

            if isLoggedIn {
                NavigationLink(destination: FlightListView(), isActive: $isLoggedIn) {
                    EmptyView()
                }.hidden()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
