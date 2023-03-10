//
//  API.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import Foundation
import Starscream

// API class for interacting with FinnHub API
class FinnHub {
    // Makes API requests to the server.
    class API {
        weak var delegate: FinnHubAPIDelegate?
        // API token for accessing FinnHub API
        fileprivate let token = "cf93lraad3i9ljn7d4c0cf93lraad3i9ljn7d4cg"
        // Base URL for FinnHub API
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
        
        // Retrieves quote for a given symbol string, completion is called with result of quote or error
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

        // Retrieves company data for a given symbol, completion is called with result of company data or error
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
        
        // Constructs the request and sends it to the API.
        fileprivate func request(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
            delegate?.isLoading(true)
            var numberOfAttempts = 0
            let endpoint = url + endpoint
            guard let url = URL(string: endpoint) else {
                delegate?.isLoading(false)
                completion(.failure(URLError(.badURL)))
                return
            }
            
            func req() {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        if 3 > numberOfAttempts {
                            // Try sending the request one more time
                            numberOfAttempts += 1
                            req()
                            return
                        }
                        // We made the request 3 times with no success, we return an error.
                        self.delegate?.isLoading(false)
                        completion(.failure(error))
                        return
                    }
                    self.delegate?.isLoading(false)
                    guard let data = data else {
                        completion(.failure(NSError(domain: "data is empty", code: 0, userInfo: nil)))
                        return
                    }
                    completion(.success(data))
                }.resume()
            }
            req()
        }
    }
    
    // Handles socket connections to the server.
    class Socket: WebSocketDelegate {
        // An array of Tickers
        private var _tickers = [Ticker]()
        private let socket = WebSocket(request: URLRequest(url: URL(string: "wss://ws.finnhub.io?token=cf93lraad3i9ljn7d4c0cf93lraad3i9ljn7d4cg")!))
        
        weak var delegate: FinnHubSocketDelegate?
        
        // Subscribes to an array of Tickers to get changes.
        func subscribe(tickers: [Ticker]) {
            _tickers = tickers
            socket.delegate = self
            socket.connect()
        }
        
        /// Handles the event when a message is received from our subscription.
        func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
            switch event {
            case .connected(_):
                _tickers.forEach { ticker in
                    do {
                        let req =  try JSONSerialization.data(withJSONObject: ["type": "subscribe", "symbol": ticker.rawValue])
                        socket.write(string: String(data: req, encoding: .utf8) ?? "")
                    } catch {
                        delegate?.disconnected(data: error.localizedDescription)
                    }
                }
            case .disconnected(let data, _):
                /**
                 Notifies the delegate that the WebSocket connection has been disconnected, passing in the data received when disconnected.
                 */
                delegate?.disconnected(data: data)
            case .text(let text):
                do {
                    let res = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!) as? [String: Any] ?? [:]
                    /**
                     Notifies the delegate of new data received on the WebSocket connection by calling the 'websocket(updated:)' method on the delegate and passing in the data processed by the 'getResponseData(res:)' method.
                     */
                    delegate?.websocket(updated: getResponseData(res: res))
                } catch {
                    delegate?.disconnected(data: error.localizedDescription)
                }
            case .error(let error):
                /**
                 Notifies the delegate of an error that occurred on the WebSocket connection by calling the 'websocket(error:)' method on the delegate and passing in the error.
                 */
                delegate?.websocket(error: error)
            case .viabilityChanged(let val):
                if !val {
                    delegate?.disconnected(data: "Can't connect to the server, please try again.")
                }
            default:
                break
            }
        }
        
        private func getResponseData(res: [String: Any]) -> LastPriceDataSubscription {
            let data = res[LastPriceDataResponse.data.rawValue] as? NSArray ?? []
            var subscriptions = [LastPriceData]()
            data.forEach { item in
                let item = item as? [String: Any] ?? [:]
                let symbol = item[LastPriceResponse.symbol.rawValue] as? String ?? ""
                let lastPrice = item[LastPriceResponse.lastPrice.rawValue] as? Double ?? 0
                let timestamp = item[LastPriceResponse.timestamp.rawValue] as? Int64 ?? 0
                let volume = item[LastPriceResponse.volume.rawValue] as? Double ?? 0
                subscriptions.append(LastPriceData(
                    symbol: symbol,
                    lastPrice: lastPrice,
                    timestamp: timestamp,
                    volume: volume
                ))
            }
            
            let type = res[LastPriceDataResponse.type.rawValue] as? String ?? ""
            let subscription = LastPriceDataSubscription(
                type: type,
                data: subscriptions
            )
            
            return subscription
        }
    }
}

class LocalDataStore {
    enum StoredDataKey: String {
        case stockList = "stockList"
    }
    
    static func storeData(forKey: StoredDataKey, _ data: Any) -> Void {
        storeData(forKey: forKey.rawValue, data)
    }
    
    static func storeData(forKey: String, _ data: Any) -> Void {
        UserDefaults.standard.set(data, forKey: forKey)
    }

    static func removeStoredData(forKey: StoredDataKey) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
    
    static func retrieveLocalData(forKey: StoredDataKey) -> AnyObject {
        return retrieveLocalData(forKey: forKey.rawValue) as AnyObject
    }
    
    static func retrieveLocalData(forKey: String) -> AnyObject {
        return UserDefaults.standard.value(forKey: forKey) as AnyObject
    }
}


public func getStockImage(ticker: String) -> UIImage {
    return UIImage(named: ticker) ?? UIImage(named: "company")!
}



protocol FinnHubSocketDelegate: AnyObject {
    func disconnected(data: String)
    func websocket(error: Error?)
    func websocket(updated: LastPriceDataSubscription)
}

protocol FinnHubAPIDelegate: AnyObject {
    func isLoading(_ loading: Bool)
}
