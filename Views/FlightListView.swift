import SwiftUI

struct FlightListView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    @State private var isLoggedIn: Bool = true // Giriş durumu için state
    private let flightService = FlightService()

    var body: some View {
        if !isLoggedIn {
            WelcomeView() // Oturum kapatıldığında WelcomeView'e dön
        } else {
            VStack {
                HStack {
                    Spacer()
                    Button("Logout") {
                        isLoggedIn = false // Oturumu kapat
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                
                if isLoading {
                    ProgressView("Loading flights...")
                } else {
                    List(flights) { flight in
                        VStack(alignment: .leading) {
                            Text("\(flight.departure) → \(flight.arrival)")
                                .font(.headline)
                            Text("Date: \(flight.formattedDate) Time: \(flight.time)")
                                .font(.subheadline)
                            Text("Capacity: \(flight.capacity), Price: \(flight.formattedPrice)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear {
                flightService.fetchFlights { result in
                    switch result {
                    case .success(let fetchedFlights):
                        DispatchQueue.main.async {
                            self.flights = fetchedFlights
                            self.isLoading = false
                        }
                    case .failure(let error):
                        print("Error fetching flights: \(error)")
                        self.isLoading = false
                    }
                }
            }
        }
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView()
    }
}
