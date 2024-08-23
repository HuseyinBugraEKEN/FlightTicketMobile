import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {// dikey olarak sıralanmış bir bileşenler grubudur.
            Text("Welcome to FlightTicketMobile")
                .font(.largeTitle)
                .padding()

            Text("Please log in or register to view available flights.")
                .font(.headline)
                .padding()

            HStack {// yatay olarak sıralanmış bir bileşenler grubudur
                Button(action: {
                    navigateToLogin()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()

                Button(action: {
                    navigateToRegister()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }
    
    private func navigateToLogin() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: LoginView())
            window.makeKeyAndVisible()
        }
    }
    
    private func navigateToRegister() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: RegisterView())
            window.makeKeyAndVisible()
        }
    }
}
