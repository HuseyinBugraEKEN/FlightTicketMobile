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
    
    
    func fetchMyFlights(userId: Int, completion: @escaping (Result<[UserFlight], Error>) -> Void) {
            let urlString = "http://localhost:5057/api/Flights/user/\(userId)"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userFlights = try decoder.decode([UserFlight].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(userFlights))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    
    
    func buyFlight(flightId: Int, userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:5057/api/Flights/buy") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let buyData = ["flightId": flightId, "userId": userId]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: buyData, options: []) else {
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func cancelFlight(flightId: Int, userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:5057/api/Flights/cancel") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let cancelData = ["flightId": flightId, "userId": userId]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: cancelData, options: []) else {
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func addFlight(_ flight: FlightCreateModel, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:5057/api/Flights") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            guard let httpBody = try? JSONEncoder().encode(flight) else {
                completion(.failure(NSError(domain: "Encoding Error", code: 0, userInfo: nil)))
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol et
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func deleteFlight(flightId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:5057/api/Flights/\(flightId)") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol et
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 204 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func updateFlight(flightId: Int, flight: FlightCreateModel, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:5057/api/Flights/\(flightId)") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let httpBody = try JSONEncoder().encode(flight)
                request.httpBody = httpBody
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol et
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 204 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
}
