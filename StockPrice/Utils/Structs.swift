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
