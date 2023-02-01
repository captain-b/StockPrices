//
//  API.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import Foundation

extension HomeViewController {
    internal func findStoredCompanyData() {
        let storedData = LocalDataStore.retrieveLocalData(forKey: .stockList)
        if (storedData.length != nil) {
            do {
                let companyArray = try JSONDecoder().decode([Company].self, from: storedData as! Data) as [Company]
                self.filterCompanies(_companies: companyArray)
            } catch {
                displayMessage(vc: self, message: error.localizedDescription)
            }
        }
        retrieveCompanyData()
    }
    
    internal func retrieveCompanyData() {
        tableViewCompanyData = [:]
        var companyArray = [Company]()
        self.companies.forEach { symbol in
            self.api.retrieveCompanyData(symbol: symbol) { result in
                switch result {
                case .success(let company):
                    companyArray.append(company)
                    if companyArray.count == self.companies.count {
                        do {
                            let encodedArray = try JSONEncoder().encode(companyArray)
                            // Store our company array data
                            LocalDataStore.storeData(forKey: .stockList, encodedArray)
                        } catch {
                            displayMessage(vc: self, message: error.localizedDescription)
                        }
                        self.filterCompanies(_companies: companyArray)
                    }
                case .failure(let error):
                    displayMessage(vc: self, message: error.localizedDescription)
                }
            }
        }
    }
    
    internal func filterCompanies(_companies: [Company]) {
        for company in _companies {
            if tableViewCompanyData[company.finnhubIndustry ?? ""] == nil {
                tableViewCompanyData[company.finnhubIndustry ?? ""] = [company]
            } else {
                tableViewCompanyData[company.finnhubIndustry ?? ""]?.append(company)
            }
        }
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
        scanPrices()
    }
}
