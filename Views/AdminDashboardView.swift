import SwiftUI

struct AdminDashboardView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showAddFlightView = false

    private let flightService = FlightService()

    var body: some View {
        VStack {
            Text("Admin Dashboard")
                .font(.largeTitle)
                .padding()

            if isLoading {
                ProgressView("Loading flights...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if flights.isEmpty {
                Text("No available flights.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(flights) { flight in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(flight.departure) → \(flight.arrival)")
                                    .font(.headline)
                                Text("Date: \(flight.formattedDate) at \(flight.formattedTime)")
                                Text("Capacity: \(flight.capacity)")
                                Text("Price: \(flight.formattedPrice)")
                            }
                            Spacer()
                            Button(action: {
                                deleteFlight(flightId: flight.id)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }

            Spacer()

            Button("Add Flight") {
                showAddFlightView = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .sheet(isPresented: $showAddFlightView) {
                AddFlightView()
            }
        }
        .padding()
        .onAppear {
            loadFlights()
        }
    }

    private func loadFlights() {
        flightService.fetchFlights { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let flights):
                    self.flights = flights
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to load flights: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    private func deleteFlight(flightId: Int) {
        flightService.deleteFlight(flightId: flightId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.flights.removeAll { $0.id == flightId }
                case .failure(let error):
                    self.errorMessage = "Failed to delete flight: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
