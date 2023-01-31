//
//  UITableView.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stockData.rawValue) as! StockTableViewCell
        return cell
    }
}
