import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to FlightTicketMobile")
                .font(.largeTitle)
                .padding()

            Text("Please log in or register to view available flights.")
                .font(.headline)
                .padding()

            HStack {
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()

                NavigationLink(destination: RegisterView()) {
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
        .navigationTitle("Welcome")
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
