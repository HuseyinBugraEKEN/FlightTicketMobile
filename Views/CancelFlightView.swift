import SwiftUI

struct CancelFlightView: View {
    var flight: UserFlight
    var userId: Int
    var onCancel: () -> Void // Uçuş iptal edildikten sonra çağrılacak callback fonksiyonu. Bu, dış view'lerdeki işlemlerin güncellenmesini sağlar.
    @Environment(\.presentationMode) var presentationMode
    @State private var cancelSuccess: Bool = false
    @State private var showMessage: Bool = false
    private let flightService = FlightService()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Do you want to cancel this flight?")
                .font(.title2)
                .padding(.bottom, 20)
            
            Text("\(flight.departure) → \(flight.arrival)")
                .font(.title3)
                .padding(.bottom, 10)
            
            Text("Date: \(flight.formattedDate)")
            Text("Time: \(flight.time)")
            Text("Price: \(flight.formattedPrice)")

            Button("Cancel Flight") {
                cancelFlight()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Go Back") { // view kapanır ve önceki ekrana geri döner.
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.blue)
            
            Spacer()

            if showMessage {
                Text(cancelSuccess ? "Flight successfully canceled!" : "Failed to cancel flight.")
                    .foregroundColor(cancelSuccess ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }

    private func cancelFlight() { // kullanıcının uçuşu iptal etmesini sağlar.
        flightService.cancelFlight(flightId: flight.id, userId: userId) { result in // FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result {// ve sonuçlara göre cancelSuccess ve showMessage değişkenleri güncellenir.
                case .success:
                    cancelSuccess = true
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showMessage = false
                        presentationMode.wrappedValue.dismiss()
                        onCancel()
                    }
                case .failure:
                    cancelSuccess = false
                    showMessage = true
                }
            }
        }
    }
}
