// Swift dilinde, property wrapper'ların (@State, @Binding vb.) arka planda kullanılan türlerine erişmek için bu property'lerin başına _ ekleyerek doğrudan o sarıcıya (wrapper'a) erişim sağlanır.

import SwiftUI

struct EditFlightView: View {
    @State private var departure: String
    @State private var arrival: String
    @State private var date: Date
    @State private var time: String
    @State private var capacity: Int
    @State private var price: String
    @State private var editSuccess: Bool = false
    @State private var showMessage: Bool = false
    @State private var errorMessage: String?

    @Environment(\.presentationMode) var presentationMode
    private let flightService = FlightService()
    var flightId: Int

    init(flight: Flight) { // EditFlightView'un bir uçuşun mevcut verileriyle başlatılmasını sağlar. @State değişkenleri uçuşun mevcut değerleriyle başlatılır.
        _departure = State(initialValue: flight.departure)
        _arrival = State(initialValue: flight.arrival)
        _date = State(initialValue: flight.date)
        _time = State(initialValue: String(flight.time.prefix(5))) // "12:12:12" yerine "12:12" olarak gösterir
        _capacity = State(initialValue: flight.capacity)
        _price = State(initialValue: String(format: "%.2f", NSDecimalNumber(decimal: flight.price).doubleValue)) // "121.21 TL" yerine "121.21" olarak göster
        self.flightId = flight.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Edit Flight")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Departure", text: $departure)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            TextField("Arrival", text: $arrival)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            DatePicker("Date", selection: $date, displayedComponents: .date)
                .padding(.bottom, 10)

            TextField("Time (HH:mm)", text: $time)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            Stepper("Capacity: \(capacity)", value: $capacity, in: 1...300)
                .padding(.bottom, 10)

            TextField("Price", text: $price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .keyboardType(.decimalPad)

            Button("Save Changes") {
                editFlight()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()

            if showMessage {
                Text(editSuccess ? "Flight successfully updated!" : (errorMessage ?? "Failed to update flight."))
                    .foregroundColor(editSuccess ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }

    private func editFlight() {
        // Boş alanları kontrol etme
        if departure.isEmpty || arrival.isEmpty || time.isEmpty || price.isEmpty {
            errorMessage = "All fields are required."
            editSuccess = false
            showMessage = true
            return
        }

        // Fiyatın uygunluğunu kontrol etme
        guard let priceValue = Decimal(string: price) else {
            errorMessage = "Invalid price format."
            editSuccess = false
            showMessage = true
            return
        }

        // Tarih formatlama
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)

        // Saat formatlama
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: timeFormatter.date(from: time) ?? Date())

        let flight = FlightCreateModel(
            departure: departure,
            arrival: arrival,
            date: formattedDate,
            time: formattedTime,
            capacity: capacity,
            price: priceValue
        )

        flightService.updateFlight(flightId: flightId, flight: flight) { result in // FlightService aracılığıyla uçuş düzenleme isteği yapılır.
            DispatchQueue.main.async {
                switch result {
                case .success: // Başarılı olursa, ekran kapanır ve başarı mesajı gösterilir.
                    editSuccess = true
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showMessage = false
                        presentationMode.wrappedValue.dismiss()
                    }
                case .failure:
                    editSuccess = false
                    errorMessage = "Failed to update flight."
                    showMessage = true
                }
            }
        }
    }
}
