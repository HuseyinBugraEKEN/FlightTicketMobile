import SwiftUI

struct FlightFilterView: View {
    @State private var departure: String = ""
    @State private var arrival: String = ""
    @State private var date: Date = Date()//Varsayılan olarak bugünün tarihi.
    @State private var passengers: Int = 1

    @Binding var flights: [Flight] //Ana uçuş listesinden gelen bir referanstır ve burada filtrelendikten sonra güncellenir.
    @Binding var isFilterActive: Bool // Filtreleme ekranının aktif olup olmadığını kontrol eder.
    private let flightService = FlightService()

    var body: some View {
        VStack {
            Text("Filter Flights")
                .font(.largeTitle)
                .padding()

            TextField("Departure", text: $departure)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Arrival", text: $arrival)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Date", selection: $date, displayedComponents: .date)
                .padding()

            Stepper("Passengers: \(passengers)", value: $passengers, in: 1...150)
                .padding()

            Button("Apply Filters") {
            // Kullanıcı filtreleri uygulamak için bu butona tıkladığında, applyFilters fonksiyonu çağrılır ve uçuşlar filtrelenir.
                applyFilters()
                isFilterActive = false //Filtreler uygulandıktan sonra filtreleme ekranı kapanır.
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }

    private func applyFilters() {
        flightService.fetchFlights { result in
            switch result {
            case .success(let fetchedFlights):
                var filteredFlights = fetchedFlights
                
                if !departure.isEmpty {
                    filteredFlights = filteredFlights.filter { $0.departure.localizedCaseInsensitiveContains(departure) }
                }

                if !arrival.isEmpty {
                    filteredFlights = filteredFlights.filter { $0.arrival.localizedCaseInsensitiveContains(arrival) }
                }

                let calendar = Calendar.current
                if calendar.isDateInToday(date) == false {
                    filteredFlights = filteredFlights.filter {
                        calendar.isDate($0.date, inSameDayAs: date)
                    }
                }

                if passengers > 0 {
                    filteredFlights = filteredFlights.filter { $0.capacity >= passengers }
                }

                DispatchQueue.main.async {
                    self.flights = filteredFlights
                    self.isFilterActive = false
                }

            case .failure(let error):
                print("Error filtering flights: \(error)")
            }
        }
    }

}
