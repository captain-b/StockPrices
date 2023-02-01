//
//  CompanyInfoViewController.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class CompanyInfoViewController: UIViewController {
    internal let naString = "N/A"
    var company = Company()
    let socket = FinnHub.Socket()
    let api = FinnHub.API()
    
    @IBOutlet weak var stockPriceLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyCountryLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyIndustryLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyNameLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyLogoImageView: CompanyLogoImageView!
    @IBOutlet weak var companyExchangeLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyMarketCapLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyOutsandingSharesLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyWebsiteLabel: GrayDescriptionLabel!
    @IBOutlet weak var companyPhoneLabel: GrayDescriptionLabel!
    
    @IBAction func closeButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        displayStockPrice()
    }
    
    /// Sets the value of our labels.
    func setLabels() {
        companyNameLabel.text = "Name: \(company.name!) (\(company.ticker!))"
        companyIndustryLabel.text = "Industry: \(company.finnhubIndustry!)"
        companyLogoImageView.image = getStockImage(ticker: company.ticker!)
        companyExchangeLabel.text = "Exchange: \(company.exchange ?? naString)"
        companyMarketCapLabel.text = "Market cap: \(company.marketCapitalization ?? 0)"
        companyPhoneLabel.text = "Phone: \(company.phone ?? naString)"
        companyWebsiteLabel.text = "Website: \(company.weburl ?? naString)"
        companyOutsandingSharesLabel.text = "Outsanding sharess: \(company.shareOutstanding ?? 0)"
        companyCountryLabel.text = "Country: \(company.country ?? naString)"
    }
}
