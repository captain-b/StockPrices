//
//  HomeViewController.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var stocksTableView: UITableView!
    internal let activityIndicator = UIActivityIndicatorView(style: .gray)
    internal let companies: [Ticker] = [.Google, .Apple, .Meta, .Tesla, .Amazon, .Coke]
    internal var companyData = [Company]()
    internal var tableViewCompanyData: [String: [Company]] = [:]
    internal let socket = FinnHub.Socket()
    internal let api = FinnHub.API()
    internal var companyToOpen = Company()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set our delegates
        setDelegates()
        // Triggers a chain of function, starting with the previously stored company stock data.
        findStoredCompanyData()
    }
    
    private func setDelegates() {
        api.delegate = self
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.register(UINib(nibName: NibIdentifier.stockTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.stockData.rawValue)
        socket.delegate = self
    }
}
