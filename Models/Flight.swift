import Foundation

struct Flight: Identifiable, Codable {
    var id: Int
    var departure: String
    var arrival: String
    var date: String
    var time: String
    var capacity: Int
    var price: Double
    
    var formattedPrice: String {
        String(format: "%.2f", price)
    }
    
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: self.date) {
            return outputFormatter.string(from: date)
        }
        
        return self.date
    }
}
