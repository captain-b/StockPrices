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
        
        func getQuote(symbol: Ticker, completion: @escaping (Result<Quote, Error>) -> Void) {
            getQuote(symbol: symbol.rawValue) { result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func getQuote(symbol: String, completion: @escaping (Result<Quote, Error>) -> Void) {
            request(endpoint: "/quote?symbol=\(symbol)&token=\(token)") { data in
                switch data {
                case .success(let data):
                    do {
                        let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
                        let quote = Quote(
                            currentPrice: result[QuoteResponse.currentPrice.rawValue] as? Double ?? 0,
                            change: result[QuoteResponse.change.rawValue] as? Double ?? 0,
                            percentChange: result[QuoteResponse.percentChange.rawValue] as? Double ?? 0,
                            highPrice: result[QuoteResponse.highPrice.rawValue] as? Double ?? 0,
                            lowPrice: result[QuoteResponse.lowPrice.rawValue] as? Double ?? 0,
                            openPrice: result[QuoteResponse.openPrice.rawValue] as? Double ?? 0,
                            previousClosePrice: result[QuoteResponse.previousClosePrice.rawValue] as? Double ?? 0
                        )
                        completion(.success(quote))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        
        func retrieveCompanyData(symbol: Ticker, completion: @escaping (Result<Company, Error>) -> Void) {
            request(endpoint: "/stock/profile2?symbol=\(symbol.rawValue)&token=\(token)") { result in
                switch result {
                case .success(let data):
                    do {
                        completion(.success(try JSONDecoder().decode(Company.self, from: data)))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
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
