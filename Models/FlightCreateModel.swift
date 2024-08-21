import Foundation

struct FlightCreateModel: Codable {
    var departure: String
    var arrival: String
    var date: String
    var time: String
    var capacity: Int
    var price: Decimal
}
