import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var registrationSuccess: Bool = false
    @State private var registrationError: String?
    private let registerService = RegisterService()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(TextFieldModifiers())

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(TextFieldModifiers())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(TextFieldModifiers())

            Button("Register") {
                registerService.register(username: username, password: password, email: email) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            if success {
                                registrationSuccess = true
                                registrationError = nil
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            } else {
                                registrationError = "Registration failed"
                                registrationSuccess = false
                            }
                        case .failure(let error):
                            registrationError = error.localizedDescription
                            registrationSuccess = false
                        }
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            if let error = registrationError {
                Text("try again")
                    .foregroundColor(.red)
                    .padding()
            }

            if registrationSuccess {
                Text("Registration Successful!")
                    .padding()
            }
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
