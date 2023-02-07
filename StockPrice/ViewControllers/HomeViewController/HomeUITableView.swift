//
//  UITableView.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Counts the number of industries and returns the number of sections.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[section]
        return tableViewCompanyData[industry]?.count ?? 0
    }
    
    // Determines which row is selected and prepares the company data to be sent to our CompanyInfoViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[indexPath.section]
        let company = tableViewCompanyData[industry]?[indexPath.row]
        companyToOpen = company!
        performSegue(withIdentifier: SegueIdentifier.details.rawValue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Init our custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stockData.rawValue) as! StockTableViewCell
        // Determines the section's industry name.
        let sectionTitles = Array(tableViewCompanyData.keys)
        let industry = sectionTitles[indexPath.section]
        // Determines the company to display in this cell
        let company = tableViewCompanyData[industry]?[indexPath.row]
        
        // Populate the data to our cell labels and images.
        cell.stockTickerLabel.text = company?.ticker
        cell.stockCompanyNameLabel.text = company?.name
        
        // Set a temporary image placeholder for our company logo
        let companyStockImagePlaceholder = UIImageView()
        companyStockImagePlaceholder.frame = cell.stockImageView.bounds
        cell.stockImageView.addSubview(companyStockImagePlaceholder)
        companyStockImagePlaceholder.image = UIImage(named: "company")
        
        // Fetch the image from the URL and remove the placeholder
        if ((company != nil) && ((company?.logo) != nil)) {
            companyStockImagePlaceholder.removeFromSuperview()
            let companyStockImage = SVGImageView()
            companyStockImage.frame = cell.stockImageView.bounds
            cell.stockImageView.addSubview(companyStockImage)
            companyStockImage.setImage(withUrl: company!.logo!)
        }
        
        // Retrieve our stored data
        let storedCompanyData = LocalDataStore.retrieveLocalData(forKey: company!.ticker!) as? Data
        if storedCompanyData != nil {
            do {
                if !storedCompanyData!.isEmpty { // If the data is not empty...
                    // Decode the quote data and display it to the user.
                    let quote = try JSONDecoder().decode(Quote.self, from: storedCompanyData!)
                    DispatchQueue.main.async {
                        cell.stockPriceLabel.text = "$\(quote.currentPrice)"
                    }
                }
            } catch {
                displayMessage(vc: self, message: "Failed to retrieve previously stored quote. Attempting to fetch the price now.")
            }
        }
        
        
        
        // Get company stock quotes from our API.
        api.getQuote(symbol: company!.ticker!) { result in
            switch result {
                case .success(let quote):
                do { // Encode our Quote object and store it.
                    let encoded = try JSONEncoder().encode(quote)
                    LocalDataStore.storeData(forKey: company!.ticker!, encoded)
                } catch {
                    displayMessage(vc: self, message: error.localizedDescription)
                }
                // Display the updated stock price.
                DispatchQueue.main.async {
                    cell.stockPriceLabel.text = "\(quote.currentPrice)"
                }
                default: break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Returns the section name.
        let sectionTitles = Array(tableViewCompanyData.keys)
        return sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns the number of section.
        return tableViewCompanyData.count
    }
    
    /// Updates the cell's price label and changes its color to either green or red, depending on if the stock price goes up or down.
    func changeCell(priceData: LastPriceData, row: Array<Company>.Index, section: String) {
        let sectionTitles = Array(tableViewCompanyData.keys)
        let indexPath = IndexPath(row: row, section: sectionTitles.firstIndex(of: section)!)
        if let cell = stocksTableView.cellForRow(at: indexPath) as? StockTableViewCell {
            let previousPrice = Double((cell.stockPriceLabel.text!).replacingOccurrences(of: "$", with: "")) ?? 0
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
