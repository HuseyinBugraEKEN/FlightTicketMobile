import Foundation

class RegisterService {
    func register(username: String, password: String, email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5057/api/Auth/register") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let registerData = ["username": username, "password": password, "email": email]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: registerData, options: []) else {
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
                   jsonResponse["username"] != nil {
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
