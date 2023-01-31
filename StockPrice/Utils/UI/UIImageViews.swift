//
//  UIImageViews.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class CompanyLogoImageView: UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyles()
    }
    
    private func setStyles() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
