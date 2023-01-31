//
//  API.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import Foundation

class FinnHub {
    class API {
        fileprivate let token = "cf93lraad3i9ljn7d4c0cf93lraad3i9ljn7d4cg"
        fileprivate let url = "https://finnhub.io/api/v1"
        
        
        fileprivate func request(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
            let endpoint = url + endpoint
            guard let url = URL(string: endpoint) else {
                completion(.failure(URLError(.badURL)))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "data is empty", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(data))
            }.resume()
        }
    }
    
    class Socket {
        
    }
}