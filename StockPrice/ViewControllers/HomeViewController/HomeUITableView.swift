//
//  UITableView.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[section]
        return tableViewCompanyData[industry]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[indexPath.section]
        let company = tableViewCompanyData[industry]?[indexPath.row]
        companyToOpen = company!
        performSegue(withIdentifier: SegueIdentifier.details.rawValue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stockData.rawValue) as! StockTableViewCell
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[indexPath.section]
        let company = tableViewCompanyData[industry]?[indexPath.row]
        
        cell.stockTickerLabel.text = company?.ticker
        cell.stockCompanyNameLabel.text = company?.name
        cell.stockImage.image = getStockImage(ticker: company!.ticker!)
        api.getQuote(symbol: company!.ticker!) { result in
            switch result {
                case .success(let quote):
                DispatchQueue.main.async {
                    cell.stockPriceLabel.text = "\(quote.currentPrice)"
                }
                default: break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = Array(tableViewCompanyData.keys)
        return sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewCompanyData.count
    }
    
    func changeCell(priceData: LastPriceData, row: Array<Company>.Index, section: String) {
        let sectionTitles = Array(tableViewCompanyData.keys)
        let indexPath = IndexPath(row: row, section: sectionTitles.firstIndex(of: section)!)
        if let cell = stocksTableView.cellForRow(at: indexPath) as? StockTableViewCell {
            let previousPrice = Double((cell.stockPriceLabel.text!).replacingOccurrences(of: "$", with: ""))!
            if  previousPrice > priceData.lastPrice {
                cell.stockPriceLabel.textColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
            }
            
            if  previousPrice < priceData.lastPrice {
                cell.stockPriceLabel.textColor = UIColor(red: 0/255, green: 115/255, blue: 13/255, alpha: 1)
            }

            cell.stockPriceLabel.text = "$\(priceData.lastPrice)"
        }
    }
}
