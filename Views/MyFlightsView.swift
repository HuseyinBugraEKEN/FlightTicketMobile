import SwiftUI

struct MyFlightsView: View {
    @State private var myFlights: [UserFlight] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var userId: Int
    
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
            }
            .navigationTitle("My Flights")
            .onAppear {
                loadMyFlights()
            }
        }
    }
    
    private func loadMyFlights() {
        flightService.fetchMyFlights(userId: userId) { result in
            switch result {
            case .success(let flights):
                self.myFlights = flights
                self.isLoading = false
            case .failure(let error):
                self.errorMessage = "Failed to load flights: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}

struct MyFlightsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFlightsView(userId: 7)
    }
}
