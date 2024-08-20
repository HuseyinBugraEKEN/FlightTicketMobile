import SwiftUI

struct AdminDashboardView: View {
    var body: some View {
        VStack {
            Text("Admin Dashboard")
                .font(.largeTitle)
                .padding()

            // Burada uçuş ekleme, düzenleme, silme ve kullanıcıların e-postalarını görme işlevleri olacak butonlar ekleyebilirsiniz.
            
            Button("Add Flight") {
                // Uçuş ekleme işlevi
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Edit Flight") {
                // Uçuş düzenleme işlevi
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Delete Flight") {
                // Uçuş silme işlevi
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("View Users Emails") {
                // Kullanıcıların e-posta adreslerini gösterme işlevi
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
