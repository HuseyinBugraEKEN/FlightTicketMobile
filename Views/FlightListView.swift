import SwiftUI

struct FlightListView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    @State private var isLoggedIn: Bool = true
    @State private var isFilterActive: Bool = false
    @State private var isMyFlightsActive: Bool = false
    @State private var selectedFlight: Flight? = nil // Seçilen uçuş
    var userRole: String
    var userId: Int
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
            } else {// Uçuşlar başarıyla yüklendiğinde, kullanıcıya bir liste halinde sunulur.
                List(flights) { flight in
                    Button(action: {// Her bir uçuş listede bir buton olarak gösterilir.
                        selectedFlight = flight// Bu butona tıklanarak uçuş seçilebilir ve detaylar görüntülenebilir.
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
                // Kullanıcı bir uçuş seçtiğinde, uçuş detaylarını gösteren bir ekran (FlightDetailView) açılır.
                    FlightDetailView(flight: flight, userId: userId, userRole: userRole, onCompletion: {
                        loadFlights() // Satın alma veya iptal sonrası uçuş listesini yeniler.
                    })
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isFilterActive) {// Filtreleme ekranı aktif olduğunda, FlightFilterView açılır.
            FlightFilterView(flights: $flights, isFilterActive: $isFilterActive)
        }
        .sheet(isPresented: $isMyFlightsActive) {// Kullanıcının satın aldığı uçuşları gösteren ekran aktif olduğunda, MyFlightsView açılır.
            MyFlightsView(userId: userId, onCompletion: {
                loadFlights() // Satın alma veya iptal sonrası uçuş listesini yeniler
            })
        }
        .onAppear {// Bir view ilk defa ekranda göründüğünde (onAppear) çağrılan bir closure (kod bloğu) tanımlar. Bu, view'in yüklenmesi sırasında belirli işlemleri (loadFlights) tetiklemek için kullanılır.
            loadFlights()
        }
    }
    
    private func loadFlights() {
    // Uçuşları sunucudan almak için kullanılır. FlightService aracılığıyla bir API isteği yapılır
        isLoading = true
        flightService.fetchFlights { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let flights):
                    self.flights = flights
                case .failure(let error):
                    print("Error fetching flights: \(error.localizedDescription)")
                }
                self.isLoading = false
            }
        }
    }
}
