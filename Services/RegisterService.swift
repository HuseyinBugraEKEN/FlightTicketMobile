import Foundation

class RegisterService {
    func register(username: String, password: String, email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
// Bu metod, kullanıcı adı, şifre ve e-posta adresini alarak belirtilen URL’ye bir POST isteği gönderir ve bu işlemin sonucunu Bool olarak döndürür
        guard let url = URL(string: "http://localhost:5057/api/Auth/register") else { // API’ye istek göndermek için URL
            return
        }

        var request = URLRequest(url: url)// URL’ye gönderilecek olan request
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Request gövdesinin JSON formatında olduğunu belirtmek için Content-Type başlığını ayarlar.

        let registerData = ["username": username, "password": password, "email": email]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: registerData, options: []) else {
            // Dictionary verilerini JSON formatına dönüştürür.
            return
        }

        request.httpBody = httpBody // JSON verilerini request gövdesine ekler.

        URLSession.shared.dataTask(with: request) { data, response, error in
            //API'ye istek gönderir ve sunucudan gelen yanıtı işler.
            if let error = error { //Eğer istek sırasında bir hata oluşursa, closure'a gönderilir, metod sonlandırılır.
                completion(.failure(error))
                return
            }

            guard let data = data else { // Herhangi bir veri dönmezse hata.
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   jsonResponse["username"] != nil { // Gelen JSON verisini dictionary olarak açar, username verisi var ise True döner.
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            } catch let decodingError { // Eğer JSON verisi düzgün bir şekilde çözümlenemezse hata.
                completion(.failure(decodingError))
            }
        }.resume()//URLSession işlemini başlatır.
    }
}
