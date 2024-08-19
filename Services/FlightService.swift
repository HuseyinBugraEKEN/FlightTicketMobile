import Foundation

class FlightService {
    func fetchFlights(completion: @escaping (Result<[Flight], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5057/api/Flights") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return
            }

            do {
                let flights = try JSONDecoder().decode([Flight].self, from: data)
                completion(.success(flights))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}
