//
//  StockTableViewCell.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var stockImage: CompanyLogoImageView!
    @IBOutlet weak var stockPriceLabel: BlackBoldLabel!
    @IBOutlet weak var stockCompanyNameLabel: GrayDescriptionLabel!
    @IBOutlet weak var stockTickerLabel: BlackBoldLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
