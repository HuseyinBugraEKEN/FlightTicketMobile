import SwiftUI

struct FlightDetailView: View {
    var flight: Flight
    var userId: Int
    var userRole: String
    var onCompletion: () -> Void // Uçuş satın alındıktan sonra çağrılacak callback fonksiyonu.
    @Environment(\.presentationMode) var presentationMode
    @State private var purchaseSuccess: Bool = false
    @State private var showMessage: Bool = false
    private let flightService = FlightService()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(flight.departure) → \(flight.arrival)")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            Text("Date: \(flight.formattedDate)")
            Text("Time: \(flight.formattedTime)")
            Text("Capacity: \(flight.capacity)")
            Text("Price: \(flight.formattedPrice)")

            if userRole.lowercased() != "admin" { // Kullanıcının rolü "admin" değilse, buton görünür hale gelir.
                Button("Buy Flight") {
                    buyFlight()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()//view'i kapatır ve önceki ekrana döner.

            }
            .padding()
            .foregroundColor(.blue)

            Spacer()

            if showMessage {
                Text(purchaseSuccess ? "Flight successfully purchased!" : "Failed to purchase flight.")
                    .foregroundColor(purchaseSuccess ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }

    private func buyFlight() { // Kullanıcının uçuşu satın almasını sağlar.
        flightService.buyFlight(flightId: flight.id, userId: userId) { result in // FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result { // ve sonuçlara göre purchaseSuccess ve showMessage değişkenleri güncellenir.
                case .success:
                    purchaseSuccess = true
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showMessage = false
                        presentationMode.wrappedValue.dismiss()
                        onCompletion()
                    }
                case .failure:
                    purchaseSuccess = false
                    showMessage = true
                }
            }
        }
    }
}
