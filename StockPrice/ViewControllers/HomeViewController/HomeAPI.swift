//
//  API.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import Foundation

extension HomeViewController {
    func findCompanyData() {
        var companyArray = [Company]()
        self.companies.forEach { symbol in
            self.api.retrieveCompanyData(symbol: symbol) { result in
                switch result {
                case .success(let company):
                    companyArray.append(company)
                    if companyArray.count == self.companies.count {
                        self.filterCompanies(_companies: companyArray)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func filterCompanies(_companies: [Company]) {
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
