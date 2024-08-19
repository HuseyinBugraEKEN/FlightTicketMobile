import Foundation

struct Flight: Codable, Identifiable {
    var id: Int
    var departure: String
    var arrival: String
    var date: Date
    var time: String
    var capacity: Int
    var price: Decimal

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var formattedPrice: String {
        return String(format: "%.2f", NSDecimalNumber(decimal: price).doubleValue)
    }


    enum CodingKeys: String, CodingKey {
        case id, departure, arrival, date, time, capacity, price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        departure = try container.decode(String.self, forKey: .departure)
        arrival = try container.decode(String.self, forKey: .arrival)
        time = try container.decode(String.self, forKey: .time)
        capacity = try container.decode(Int.self, forKey: .capacity)
        price = try container.decode(Decimal.self, forKey: .price)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateValue = formatter.date(from: dateString) {
            date = dateValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
