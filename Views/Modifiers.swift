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
