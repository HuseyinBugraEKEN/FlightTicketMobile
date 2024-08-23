import SwiftUI

struct AdminDashboardView: View {
    @State private var flights: [Flight] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showAddFlightView = false
    @State private var selectedFlight: Flight?
    @State private var selectedUserEmails: [String] = []
    @State private var showUserEmails = false

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
            } else { //Uçuşlar başarıyla yüklendiğinde, kullanıcıya bir liste halinde sunulur.
                List {
                    ForEach(flights) { flight in //Her bir uçuş listede bir HStack olarak gösterilir
                        HStack { //Uçuş detayları
                            VStack(alignment: .leading) {
                                Text("\(flight.departure) → \(flight.arrival)")
                                    .font(.headline)
                                Text("Date: \(flight.formattedDate) at \(flight.formattedTime)")
                                Text("Capacity: \(flight.capacity)")
                                Text("Price: \(flight.formattedPrice)")
                            }
                            Spacer()
                            HStack { // edit, silme, kullanıcı mailleri
                                Button(action: { // edit
                                    selectedFlight = flight
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                                .padding(.trailing, 10)

                                Button(action: { // silme
                                    deleteFlight(flightId: flight.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.trailing, 10)

                                Button(action: { // kullanıcı mailleri
                                    fetchUserEmails(flightId: flight.id)
                                }) {
                                    Text("View Users")
                                        .foregroundColor(.blue)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .sheet(item: $selectedFlight, onDismiss: {// Bir uçuş düzenlemek için EditFlightView ekranı açılır. Düzenleme tamamlandıktan sonra uçuşlar yeniden yüklenir.
                    loadFlights()})
                { flight in
                    EditFlightView(flight: flight)
                }
                .alert(isPresented: $showUserEmails) {// Kullanıcıların e-posta adreslerini bir Alert olarak gösterir. E-posta adresleri alt alta listelenir.
                    Alert(
                        title: Text("Users who bought this flight"),
                        message: Text(selectedUserEmails.joined(separator: "\n")), //E-posta adresleri alt alta listelenir.
                        dismissButton: .default(Text("OK"))
                    )
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
            .sheet(isPresented: $showAddFlightView, onDismiss: { //Uçuş eklemek için AddFlightView ekranı açılır. Yeni bir uçuş eklendikten sonra uçuşlar yeniden yüklenir.
                loadFlights()
            }) {
                AddFlightView()
            }
        }
        .padding()
        .onAppear {
            loadFlights()
        }
    }

    private func loadFlights() { //Uçuşları sunucudan almak için kullanılır.
        flightService.fetchFlights { result in // FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result { // ve sonuçlara göre flights listesi güncellenir.
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

    private func deleteFlight(flightId: Int) { // Belirtilen uçuşu silmek için kullanılır.
        flightService.deleteFlight(flightId: flightId) { result in //FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result { // ve uçuş başarıyla silinirse flights listesinden kaldırılır.
                case .success:
                    self.flights.removeAll { $0.id == flightId }
                case .failure(let error):
                    self.errorMessage = "Failed to delete flight: \(error.localizedDescription)"
                }
            }
        }
    }

    private func fetchUserEmails(flightId: Int) { // belirtilen uçuşu satın alan kullanıcıların e-posta adreslerini almak için kullanılır.
        flightService.fetchUserEmailsByFlightId(flightId: flightId) { result in // FlightService aracılığıyla bir API isteği yapılır
            DispatchQueue.main.async {
                switch result { // ve sonuçlar selectedUserEmails listesine eklenir.
                case .success(let emails):
                    self.selectedUserEmails = emails
                    self.showUserEmails = true
                case .failure(let error):
                    self.errorMessage = "Failed to fetch user emails: \(error.localizedDescription)"
                }
            }
        }
    }
}
