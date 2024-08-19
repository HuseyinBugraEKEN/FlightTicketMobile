import Foundation

class AuthService {
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5057/api/Auth/login") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = ["username": username, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: []) else {
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
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   jsonResponse["id"] != nil {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}
