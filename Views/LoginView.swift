/*  @State
 Kullanıcı arayüzündeki etkileşimlere bağlı olarak view'in otomatik olarak güncellenmesi gerektiğinde @State kullanılır.
 Yalnızca bir view içinde geçerli olan yerel durumlar için kullanılır. Bu, view'in dışından erişilemeyen durumlar için uygundur.
 @State değişkenleri güncellendiğinde, view otomatik olarak yeniden çizilir ve bu sayede kullanıcı arayüzü her zaman güncel kalır.
 */
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String?
    @State private var userRole: String = ""
    @State private var userId: Int = 0
    private let authService = AuthService()

    var body: some View { // LoginView'un kullanıcıya gösterilen görünümünü tanımlar.
        NavigationStack { // İçindeki görünümler bir stack halinde organize edilir ve kullanıcı belirli bir ekran üzerinde ileri veya geri gidebilir.
            VStack { // Dikey olarak sıralanmış bir bileşenler grubudur.
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)// Kullanıcı username girmesi için bir metin alanı
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)// Oto büyük harf kapalı
                    .disableAutocorrection(true) // Oto düzeltme kapalı
                    .padding(.horizontal)

                SecureField("Password", text: $password)// Kullanıcının password girmesi için gizli bir metin alanı. Girilen karakterler gizlenir.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Login") {// Tıklanınca authService.login fonksiyonu çalışır
                    authService.login(username: username, password: password) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let user):
                                print("Logged in user: \(user)")
                                self.userRole = user.role
                                self.userId = user.id
                                self.isLoggedIn = true
                            //Giriş başarılı olursa, userRole ve userId gibi kullanıcı bilgileri alınır ve isLoggedIn durumu true olarak ayarlanır.
                                
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
                // Eğer loginError değişkeni bir hata içeriyorsa, bu hata ekranda kırmızı renkli bir metin olarak gösterilir.
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink( // Kullanıcı giriş yaptıktan sonra, userRole değişkenine göre Admin ya da Client ekranına yönlendirilir.
                    destination: userRole.lowercased() == "admin" ? AnyView(AdminDashboardView()) : AnyView(FlightListView(userRole: userRole, userId: userId)),
                    isActive: $isLoggedIn)
                {
                    EmptyView()
                }

                Spacer()

                Button("Go Back") {
                // Kullanıcı bu düğmeye tıkladığında, navigateToWelcome fonksiyonu çalışır ve kullanıcıyı welcome ekranına geri yönlendirir.
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
    // Uygulamanın ana window değiştirerek, kullanıcıyı WelcomeView adlı karşılama ekranına yönlendirir.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: WelcomeView())
            window.makeKeyAndVisible()
        }
    }
}
