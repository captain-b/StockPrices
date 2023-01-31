//
//  CompanyInfoViewController.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class CompanyInfoViewController: UIViewController {
    var company = Company()
    
    @IBOutlet weak var companyPriceLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyIndustryLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyNameLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyLogoImageView: CompanyLogoImageView!
    @IBAction func closeButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    func setLabels() {
        companyNameLabel.text = "Name: \(company.name!) (\(company.ticker!))"
        companyIndustryLabel.text = "Industry: \(company.finnhubIndustry!)"
        companyLogoImageView.image = getStockImage(ticker: company.ticker!)
    }
}
