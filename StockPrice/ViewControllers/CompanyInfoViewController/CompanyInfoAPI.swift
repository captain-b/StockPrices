//
//  CompanyInfoAPI.swift
//  StockPrice
//
//  Created by Babak Rezai on 01/02/2023.
//

import Foundation

extension CompanyInfoViewController {
    /// Retrieves and displays our company stock price
    internal func displayStockPrice() {
        api.getQuote(symbol: Ticker(rawValue: company.ticker!)!.rawValue) { result in
            switch result {
            case .success(let quote):
                self.displayQuote(quote)
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    private func displayQuote(_ quote: Quote) {
        DispatchQueue.main.async {
            self.stockPriceLabel.text = "Stock price: $\(quote.currentPrice)"
        }
    }
    
    private func displayError(_ error: Error) {
        displayMessage(vc: self, message: "There wan an error retrieving the stoc price.\n\(error.localizedDescription)")
        DispatchQueue.main.async {
            self.stockPriceLabel.text = self.naString
        }
    }
}
