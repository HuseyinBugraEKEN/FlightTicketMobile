import Foundation

struct FlightFilterModel: Codable {
    var departure: String
    var arrival: String
    var date: Date
    var passengers: Int
}
