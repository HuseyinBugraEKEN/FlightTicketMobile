import SwiftUI

struct ContentView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    private let flightService = FlightService()

    var body: some View {
        NavigationView {
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
            .navigationTitle("Flights")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .foregroundColor(.blue)
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
