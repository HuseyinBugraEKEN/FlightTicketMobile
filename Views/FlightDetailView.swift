import SwiftUI

struct FlightDetailView: View {
    var flight: Flight
    var userId: Int
    var userRole: String
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

            if userRole.lowercased() != "admin" {
                Button("Buy Flight") {
                    buyFlight()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.blue)

            Spacer()

            // Satın alma başarılı olduğunda gösterilecek mesaj
            if showMessage {
                Text(purchaseSuccess ? "Flight successfully purchased!" : "Failed to purchase flight.")
                    .foregroundColor(purchaseSuccess ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }

    private func buyFlight() {
        flightService.buyFlight(flightId: flight.id, userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    purchaseSuccess = true
                case .failure:
                    purchaseSuccess = false
                }
                showMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if purchaseSuccess {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
