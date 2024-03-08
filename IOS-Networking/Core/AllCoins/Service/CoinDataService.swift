//
//  CoinDataService.swift
//  IOS-Networking
//
//  Created by Đoàn Văn Khoan on 02/03/2024.
//

import Foundation

/*
 {
   "bitcoin": {
     "usd": 61896
   }
 }
 */


class CoinDataService {
    let stringURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en"
    
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: stringURL) else { return [] }
    
        do{
            let (data,_) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("Fetch Coins Error with \(error)")
            return []
        }
    }
    
}


extension CoinDataService {
    func fetchCoinsWithResult(completion : @escaping(Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: stringURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: "\(httpResponse.statusCode)")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do { // use do catch for catch error so user will not see this error relative business api or etc...
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("Error parse JSON fetch Coins : \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
    
    
    // first way to handling error but it so lower level
    func fetchCoins(completion : @escaping([Coin]?, Error?) -> Void){
        guard let url = URL(string: stringURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else { return }
                        
            completion(coins, nil)
        }.resume()
    }
    
    func fetchCoin(coin : String, completion : @escaping(Double) -> Void){
        let stringURL = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: stringURL) else { return }
        
        // callback
        URLSession.shared.dataTask(with: url) { (data, response, error) in // dataTask automatic into background thread
            
            /*-------handle Error------*/
            if let error = error {
                //                    self.messageError = error.localizedDescription
                print("DEBUG:: Faild with error \(error)")
                return
            } else {
                print("Not have error")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                //                    self.messageError = "Bad HTTP Response"
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                //                    self.messageError = "Failed to fetch with statuc code::\(httpResponse.statusCode)"
                return
            }
            /*--------------------------*/
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { return } // as means convert something to something, such as json to [String : Any]
            
            guard let value = jsonObject[coin] as? [String : Double] else {
                print("DEBUG:: error \(error)")
                return
            }
            guard let price = value["usd"] else { return }
            
            // same return
            completion(price)

        }.resume()
    }

}
