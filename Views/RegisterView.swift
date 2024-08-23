// @Environment, SwiftUI'de kullanılan bir property wrapper'dır ve view'ler arasında belirli verileri veya özellikleri paylaşmak için kullanılır.

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var registrationSuccess: Bool = false
    @State private var registrationError: String?
    private let registerService = RegisterService()
    @Environment(\.presentationMode) var presentationMode
    //presentationMode view'in sunum modunu kontrol eden bir çevresel değerdir. Bu, view'in ekranı kapatmasını veya geri dönmesini sağlar. Örneğin 'Go back' butonu

    var body: some View {// RegisterView'un kullanıcıya gösterilen görünümünü tanımlar.
        VStack {// dikey olarak sıralanmış bir bileşenler grubudur.
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .textContentType(.none)

            Button("Register") {
            //Tıklanınca registerService.register fonksiyonu çalışır ve kullanıcı bilgileri sunucuya gönderilir.
                registerService.register(username: username, password: password, email: email) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            if success {// Kayıt başarılıysa..
                                registrationSuccess = true
                                registrationError = nil
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {//Welcome ekranına yönlendirme
                                    navigateToWelcome()
                                }
                            } else {// Kayıt başarısızsa..
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
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            if registrationSuccess {
                Text("Registration Successful!")
                    .padding()
            }

            Spacer()// Arayüzde bileşenler arasında boşluk yaratmak için kullanılır.

            Button("Go Back") {
                navigateToWelcome()
            }
            .padding()
            .foregroundColor(.blue)
        }
        .padding()
    }

    private func navigateToWelcome() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: WelcomeView())
            window.makeKeyAndVisible()
        }
    }
}
