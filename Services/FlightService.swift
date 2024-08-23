import Foundation

class FlightService {
    func fetchFlights(completion: @escaping (Result<[Flight], Error>) -> Void) {
// Uçuşların listesini almak için bir API çağrısı yapar. Sonucu bir closure(completion) aracılığıyla geri döner. Closure başarılı olursa [Flight] nesnelerinin listesi döner,
        guard let url = URL(string: "http://localhost:5057/api/Flights") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
        // API'ye bir HTTP GET isteği gönderir ve sunucudan gelen yanıtı işler.
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
                // Gelen JSON verisi, Flight nesnelerinin bir listesine dönüştürülür.
                completion(.success(flights))
            } catch let decodingError {//Beklenmeyen format hatası.
                completion(.failure(decodingError))
            }
        }.resume()
    }

    
    func fetchFilteredFlights(filter: FlightFilterModel, completion: @escaping (Result<[Flight], Error>) -> Void) {
    // Bir FlightFilterModel nesnesi alarak kullanıcı tarafından belirlenen kriterlere göre uçuşları almak için API çağrısı yapar.
        guard let url = URL(string: "http://localhost:5057/api/Flights/filter") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONEncoder().encode(filter) else {
        // filter parametresini JSON formatına dönüştürür. FlightFilterModel'in JSON olarak API'ye gönderilmesini sağlar.
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
                // Gelen JSON verisi, Flight nesnelerinin bir listesine dönüştürülür.
                completion(.success(flights))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
    
    
    func fetchMyFlights(userId: Int, completion: @escaping (Result<[UserFlight], Error>) -> Void) {
    // Belirli bir kullanıcının uçuşlarını almak için bir API çağrısı yapar.
            let urlString = "http://localhost:5057/api/Flights/user/\(userId)"
            guard let url = URL(string: urlString) else {
            // Oluşturulan urlString'i kullanarak bir URL nesnesi oluşturur. Eğer URL geçersizse hata döndürülür.
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            let request = URLRequest(url: url)// varsayılan olarak HTTP GET
            
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
                    // Gelen JSON verisi, UserFlight nesnelerinin bir listesine dönüştürülür.
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
    // Kullanıcının belirli bir uçuşu satın alması için bir API çağrısı yapar.
            guard let url = URL(string: "http://localhost:5057/api/Flights/buy") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let buyData = ["flightId": flightId, "userId": userId]
            // Kullanıcının uçuş satın alma işlemi için gerekli olan verileri dictionary olarak hazırlar.
            guard let httpBody = try? JSONSerialization.data(withJSONObject: buyData, options: []) else {
            // Bu sözlük verilerini JSON formatına dönüştürür. Başarısız olursa çıkar.
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { _, response, error in
            // API'ye bir HTTP POST isteği gönderir. Sunucudan dönen veri '_' ile görmezden gelinmiş. Sunucudan gelen yanıt 'response'. istek sırasında bir hata oluşursa 'error'.
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
                // Eğer işlem başarılı olursa, completion closure’ına Void bir değer iletilir.
            }.resume()
        }
    
    
    func cancelFlight(flightId: Int, userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    // Belirli bir kullanıcının belirli bir uçuşu iptal etmesi için bir API çağrısı yapar.
            guard let url = URL(string: "http://localhost:5057/api/Flights/cancel") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let cancelData = ["flightId": flightId, "userId": userId]
            // Kullanıcının uçuş iptal etme işlemi için gerekli olan verileri bir dictionary olarak hazırlar.
            guard let httpBody = try? JSONSerialization.data(withJSONObject: cancelData, options: []) else {
            // Bu dictionary verilerini JSON formatına dönüştürür.
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { _, response, error in
            // API'ye bir HTTP POST isteği gönderir ve sunucudan gelen yanıtı işler.
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
                // Eğer işlem başarılı olursa, completion closure’ına Void bir değer iletilir.
            }.resume()
        }
    
    
    func addFlight(_ flight: FlightCreateModel, completion: @escaping (Result<Void, Error>) -> Void) {
    // Bir FlightCreateModel nesnesi alarak sunucuya bir POST isteği gönderir ve uçuşu eklemeye çalışır.
            guard let url = URL(string: "http://localhost:5057/api/Flights") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            guard let httpBody = try? JSONEncoder().encode(flight) else {
            // flight parametresini JSON formatına dönüştürür.
                completion(.failure(NSError(domain: "Encoding Error", code: 0, userInfo: nil)))
                return
            }

            request.httpBody = httpBody

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol etme, Yanıtın durum kodu 201 değilse, bir hata döndürür.
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func deleteFlight(flightId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    //Bu fonksiyon, belirli bir uçuşu silmek için bir API çağrısı yapar.
            guard let url = URL(string: "http://localhost:5057/api/Flights/\(flightId)") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE" //HTTP isteğinin DELETE yöntemiyle yapılacağını belirtir.

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol etme , yanıtın durum kodu 204 değilse, bir hata döndürür.
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 204 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func updateFlight(flightId: Int, flight: FlightCreateModel, completion: @escaping (Result<Void, Error>) -> Void) {
    // Uçuş ID'sini ve güncellenmiş uçuş verilerini (FlightCreateModel) alarak sunucuya bir PUT isteği gönderir ve işlem sonucunu bir closure aracılığıyla geri döndürür.
            guard let url = URL(string: "http://localhost:5057/api/Flights/\(flightId)") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Request gövdesinin JSON formatında olduğunu belirtmek için Content-Type başlığını ayarlar.

            do {// flight parametresini JSON formatına dönüştürür ve request body'sine ekler.
                let httpBody = try JSONEncoder().encode(flight)
                request.httpBody = httpBody
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
            // API'ye bir HTTP PUT isteği gönderir ve sunucudan gelen yanıtı işler.
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Yanıtın durumunu kontrol etme, yanıtın durum kodu 204 değilse, bir hata döndürür.
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 204 {
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }

                completion(.success(()))
            }.resume()
        }
    
    
    func fetchUserEmailsByFlightId(flightId: Int, completion: @escaping (Result<[String], Error>) -> Void) {
    // Uçuş ID'sini alarak sunucuya bir GET isteği gönderir ve sonuç olarak bu uçuşa kayıtlı olan kullanıcıların e-posta adreslerini döndürür.
            guard let url = URL(string: "http://localhost:5057/api/Flights/\(flightId)/users") else {
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
            // API'ye bir HTTP GET isteği gönderir ve sunucudan gelen yanıtı işler.
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }

                do {// Gelen JSON verisi, String nesnelerinin bir listesine dönüştürülür.
                    let userEmails = try JSONDecoder().decode([String].self, from: data)
                    completion(.success(userEmails))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            }.resume()
        }
}
