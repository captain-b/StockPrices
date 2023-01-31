//
//  HomeViewController.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var stocksTableView: UITableView!
    internal let companies: [Ticker] = [.Google, .Apple, .Meta, .Tesla, .Amazon, .Coke]
    internal var companyData = [Company]()
    internal var tableViewCompanyData: [String: [Company]] = [:]
    internal let socket = FinnHub.Socket()
    internal let api = FinnHub.API()
    internal var companyToOpen = Company()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }
    
    private func setDelegates() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
    }
}
