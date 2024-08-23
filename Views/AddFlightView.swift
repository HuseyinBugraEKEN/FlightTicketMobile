import SwiftUI

struct AddFlightView: View {
    @State private var departure: String = ""
    @State private var arrival: String = ""
    @State private var date: Date = Date()
    @State private var time: String = ""
    @State private var capacity: Int = 100
    @State private var price: String = ""
    @State private var addSuccess: Bool = false
    @State private var showMessage: Bool = false
    @State private var errorMessage: String?

    @Environment(\.presentationMode) var presentationMode
    private let flightService = FlightService()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Add New Flight")
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

            Button("Add Flight") {
                addFlight()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()

            if showMessage {
                Text(addSuccess ? "Flight successfully added!" : (errorMessage ?? "Failed to add flight."))
                    .foregroundColor(addSuccess ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }

    private func addFlight() {
        // Boş alanları kontrol etme
        if departure.isEmpty || arrival.isEmpty || time.isEmpty || price.isEmpty {
            errorMessage = "All fields are required."
            addSuccess = false
            showMessage = true
            return
        }

        // Fiyatın geçerliğini kontrol etme
        guard let priceValue = Decimal(string: price) else {
            errorMessage = "Invalid price format."
            addSuccess = false
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

        flightService.addFlight(flight) { result in // FlightService aracılığıyla uçuş ekleme isteği yapılır.
            DispatchQueue.main.async {
                switch result {
                case .success:
                    addSuccess = true
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showMessage = false
                        presentationMode.wrappedValue.dismiss()
                    }
                case .failure:
                    addSuccess = false
                    errorMessage = "Failed to add flight."
                    showMessage = true
                }
            }
        }
    }
}
