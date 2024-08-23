import Foundation

struct UserFlight: Codable, Identifiable {
    let id: Int
    let departure: String
    let arrival: String
    let date: String
    let time: String
    let capacity: Int
    let price: Double
    
    var formattedDate: String {
        guard let dateObject = ISO8601DateFormatter().date(from: date) else {
// bir optional değeri güvenli bir şekilde açmak (unwrap) ve belirli bir koşulun sağlandığından emin olmak için kullanılır. Eğer koşul sağlanmazsa, guard let bloğu içinde belirtilen alternatif işlem gerçekleştirilir
            return date
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateObject)
    }
    
    var formattedPrice: String {
        return String(format: "%.2f TL", price)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "flightId"
        case departure
        case arrival
        case date
        case time
        case capacity
        case price
    }
}
