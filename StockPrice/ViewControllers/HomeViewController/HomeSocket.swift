//
//  Socket.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

extension HomeViewController: FinnHubSocketDelegate {
    internal func scanPrices() {
        socket.subscribe(tickers: companies)
    }
    
    func disconnected(data: String) {
        displayMessage(vc: self, message: data)
        scanPrices()
    }

    func websocket(error: Error?) {
        displayMessage(vc: self, message: error?.localizedDescription ?? "There was an unknown error with the socket conneciton")
    }

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

