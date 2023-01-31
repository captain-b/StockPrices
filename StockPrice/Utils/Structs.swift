//
//  Structs.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

enum Font: String {
    case PTSansBold = "PTSans-Bold"
    case PTSansRegular = "PTSans-Regular"
}

enum NibIdentifier: String {
    case stockTableViewCell = "StockTableViewCell"
}

enum Storyboard: String {
    case main = "Main"
}

enum CellIdentifier: String {
    case stockData = "stock_cell"
}

struct Company: Codable {
    var country: String?
    var currency: String?
    var exchange: String?
    var ipo: String?
    var marketCapitalization: Double?
    var name: String?
    var phone: String?
    var shareOutstanding: Double?
    var ticker: String?
    var weburl: String?
    var logo: String?
    var finnhubIndustry: String?
}

enum Ticker: String {
    /// Google
    case Google = "GOOGL"
    /// Meta
    case Meta = "META"
    /// Apple
    case Apple = "AAPL"
    /// Tesla
    case Tesla = "TSLA"
    /// Amazon
    case Amazon = "AMZN"
    /// Lloyds bank
    case Lloyds = "LYG"
    /// Coca Cola
    case Coke = "KO"
}

struct Quote {
    var currentPrice = Double()
    var change = Double()
    var percentChange = Double()
    var highPrice = Double()
    var lowPrice = Double()
    var openPrice = Double()
    var previousClosePrice = Double()
}

enum QuoteResponse: String {
    case currentPrice = "c"
    case change = "d"
    case percentChange = "dp"
    case highPrice = "h"
    case lowPrice = "l"
    case openPrice = "o"
    case previousClosePrice = "pc"
}
