/*
 ViewModifier, TextField bileşenlerine ortak ayarları tekrar tekrar uygulamak yerine, bir kere tanımlayıp her yerde kullanmanızı sağlar.
 
 #if canImport(UIKit)
 Bu koşullu derleme direktifi, belirli kodların yalnızca UIKit kitaplığı kullanılabilir olduğunda (yani iOS, iPadOS veya macOS Catalyst gibi platformlarda) çalıştırılmasını sağlar. Bu, SwiftUI'nin farklı platformlar için uyumlu hale getirilmesine yardımcı olur.
 #else
 UIKit kullanılabilir değilse (örneğin, macOS veya watchOS gibi platformlarda), bu durumda content değişmeden geri döner. Bu, modifiyer'in etkili olmadığı anlamına gelir.
 */

import SwiftUI

struct TextFieldModifiers: ViewModifier {
    func body(content: Content) -> some View {
        #if canImport(UIKit)
        return content
            .autocapitalization(.none)
            .disableAutocorrection(true)
        #else
        return content
        #endif
    }
}
