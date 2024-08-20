import SwiftUI

struct FlightListView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    @State private var isLoggedIn: Bool = true
    @State private var isFilterActive: Bool = false
    @State private var isMyFlightsActive: Bool = false
    var userRole: String
    var userId: Int // Kullanıcı ID'si
    private let flightService = FlightService()
    
    var body: some View {
        VStack {
            HStack {
                if userRole.lowercased() != "admin" {
                    Button("Filter") {
                        isFilterActive = true
                    }
                    .padding()
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Button("My Flights") {
                        isMyFlightsActive = true
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button("Logout") {
                    isLoggedIn = false
                    // Logout işlemi sonrası WelcomeView'e dönüyoruz
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(rootView: WelcomeView())
                        window.makeKeyAndVisible()
                    }
                }
                .padding()
                .foregroundColor(.red)
            }
            
            if isLoading {
                ProgressView("Loading flights...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if flights.isEmpty {
                Text("No available flights.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(flights) { flight in
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
        .navigationBarHidden(true) // Navigation bar'ı tamamen gizle
        .sheet(isPresented: $isFilterActive) {
            FlightFilterView(flights: $flights, isFilterActive: $isFilterActive)
        }
        .sheet(isPresented: $isMyFlightsActive) {
            MyFlightsView(userId: userId)
        }
        .onAppear {
            loadFlights()
        }
    }
    
    private func loadFlights() {
        flightService.fetchFlights { result in
            switch result {
            case .success(let flights):
                DispatchQueue.main.async {
                    self.flights = flights
                    self.isLoading = false
                }
            case .failure(let error):
                print("Error fetching flights: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView(userRole: "client", userId: 7)
    }
}
