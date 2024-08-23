import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let role: String
}

class AuthService {
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
// Bu metod, bir kullanıcı adı ve şifre alarak, belirtilen URL’ye bir giriş isteği gönderir ve bu işlemin sonucunu bir User nesnesi olarak döndürür.
// completion: @escaping (Result<User, Error>) -> Void: Giriş işlemi tamamlandığında çağrılacak olan bir closure'dur. Bu closure, başarılı olursa bir User nesnesi (.success), başarısız olursa bir hata (.failure) döndürür.
        guard let url = URL(string: "http://localhost:5057/api/Auth/login") else {
            return
        }

        var request = URLRequest(url: url)// URL’ye gönderilecek olan isteği tanımlar.
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
// İsteğin gövdesinin JSON formatında olduğunu belirtmek için Content-Type başlığını ayarlar.

        let loginData = ["username": username, "password": password]
// Kullanıcının girdiği kullanıcı adı ve şifreyi bir sözlük (dictionary) olarak hazırlar.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: []) 
// Bu sözlük verilerini JSON formatına dönüştürür. Eğer bu dönüşüm başarısız olursa, metod erken çıkış yapar
            else {
            return}

        request.httpBody = httpBody// JSON verilerini isteğin gövdesine ekler.

        URLSession.shared.dataTask(with: request) { data, response, error in
// Bu kısım, API'ye istek gönderir ve sunucudan gelen yanıtı işler. Bu işlem asenkron olarak gerçekleştirilir, yani bu kod çalışırken uygulamanın diğer bölümleri çalışmaya devam eder.
            if let error = error {// Eğer istek sırasında bir hata olursa closure'a gönder ve kapat.
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)// Gelen JSON verisi, bir User nesnesine dönüştürülür.
                completion(.success(user))// Dönüştürülen User nesnesi, başarılı bir sonuç olarak closure’a gönderilir.
            } catch let decodingError {
                completion(.failure(decodingError))// dönüştürülemezse, bir hata oluşur ve bu hata closure'a gönderilir.
            }
        }.resume()//URLSession işlemini başlatır. Bu satır olmadan, istek gönderilmez.
    }
}
