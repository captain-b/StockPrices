//
//  HomeSegue.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Passes the selected company data to our CompanyInfoViewController.
        let companyDetailsPage = segue.destination as! CompanyInfoViewController
        companyDetailsPage.company = companyToOpen
    }
}

