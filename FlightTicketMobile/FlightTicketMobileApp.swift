import SwiftUI

@main // Uygulamanın ana giriş noktasını belirtir. Yani, uygulama çalıştırıldığında ilk olarak bu sınıf çalıştırılır.
struct FlightTicketMobileApp: App { // App protokolünü uygulayan bu yapı, uygulamanın yaşam döngüsünü yönetir ve uygulamanın ana kullanıcı arayüzünü (body) sağlar.
    var body: some Scene { // Uygulamanın kullanıcı arayüzünü tanımlar ve bir veya daha fazla Scene içerir.
        WindowGroup { // Uygulamanın ana penceresini oluşturur ve uygulamanın ilk view'ini tanımlar.
            WelcomeView()
        }
    }
}
