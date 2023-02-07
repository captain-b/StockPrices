//
//  Socket.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

extension HomeViewController: FinnHubSocketDelegate {
    /// Subscribes to an array of company tickers.
    internal func scanPrices() {
        socket.subscribe(tickers: companies)
    }
    
    /// Handles the disconnection of the socket by recalling scanPrice().
    func disconnected(data: String) {
        displayMessage(vc: self, message: data)
        scanPrices()
    }

    /// Displays a popup error message in case of a websocket error.
    func websocket(error: Error?) {
        displayMessage(vc: self, message: error?.localizedDescription ?? "There was an unknown error with the socket conneciton")
        scanPrices()
    }

    /// Handles the socket subscription events. This function loops through the response array and updates the quotes for each company table view cell.
    func websocket(updated: LastPriceDataSubscription) {
        updated.data.forEach { priceData in
            for (section, companies) in tableViewCompanyData {
                if let row = companies.firstIndex(where: { $0.ticker == priceData.symbol }) {
                    changeCell(priceData: priceData, row: row, section: section)
                }
            }
        }
    }
    
}

