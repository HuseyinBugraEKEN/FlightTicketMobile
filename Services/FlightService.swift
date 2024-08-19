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
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
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

    func fetchFilteredFlights(filter: FlightFilterModel, completion: @escaping (Result<[Flight], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5057/api/Flights/filter") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONEncoder().encode(filter) else {
            return
        }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
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
