import SwiftUI

struct MyFlightsView: View {
    @State private var myFlights: [UserFlight] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedFlight: UserFlight? = nil
    var userId: Int
    var onCompletion: () -> Void // İşlem tamamlandığında çağrılacak callback
    @Environment(\.presentationMode) var presentationMode

    private let flightService = FlightService()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading your flights...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if myFlights.isEmpty {
                    Text("You have no booked flights.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(myFlights) { flight in
                        Button(action: {
                            selectedFlight = flight
                        }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(flight.departure) → \(flight.arrival)")
                                    .font(.headline)
                                Text("Date: \(flight.formattedDate) at \(flight.time)")
                                    .font(.subheadline)
                                Text("Capacity: \(flight.capacity)")
                                    .font(.subheadline)
                                Text("Price: \(flight.formattedPrice)")
                                    .font(.subheadline)
                            }
                            .padding(5)
                        }
                    }
                    .sheet(item: $selectedFlight) { flight in
                        CancelFlightView(flight: flight, userId: userId, onCancel: {
                            loadMyFlights() // İptal sonrası uçuş listesini yenile
                            onCompletion() // FlightListView'deki listeyi de yenile
                        })
                    }
                }

                Spacer()

                // Go Back butonu
                Button("Go Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(.blue)
            }
            .navigationTitle("My Flights")
            .onAppear {
                loadMyFlights()
            }
        }
    }
    
    private func loadMyFlights() {
        isLoading = true
        flightService.fetchMyFlights(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let flights):
                    self.myFlights = flights
                case .failure(let error):
                    self.errorMessage = "Failed to load flights: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
}
