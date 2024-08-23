import SwiftUI

struct MyFlightsView: View {
    @State private var myFlights: [UserFlight] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedFlight: UserFlight? = nil
    var userId: Int
    var onCompletion: () -> Void // İşlem tamamlandığında çağrılacak callback (uçuş listesinin yenilenmesi)
    @Environment(\.presentationMode) var presentationMode

    private let flightService = FlightService()
    
    var body: some View {
        NavigationView {// içindeki bileşenlere bir navigasyon çubuğu ekler ve view'ler arasında geçiş yapmayı sağlar.
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
                } else {// Uçuşlar başarıyla yüklendiğinde, kullanıcıya bir liste halinde sunulur.
                    List(myFlights) { flight in
                        Button(action: {
                            selectedFlight = flight
                        }) {
                            VStack(alignment: .leading, spacing: 5) { // Her bir uçuş listede bir VStack olarak gösterilir
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
                    .sheet(item: $selectedFlight) { flight in // ve kullanıcı bu uçuşa tıklayarak iptal edebilir.
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
    
    private func loadMyFlights() { // kullanıcının rezervasyon yaptığı uçuşları sunucudan almak için kullanılır.
        isLoading = true
        flightService.fetchMyFlights(userId: userId) { result in // FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result { // ve sonuçlara göre myFlights listesi güncellenir.
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
