//
//  UILabels.swift
//  StockPrice
//
//  Created by Babak Rezai on 31/01/2023.
//

import UIKit

class BlackBoldLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyles()
    }
    
    private func setStyles() {
        font = UIFont(name: Font.PTSansBold.rawValue, size: font.pointSize)
        adjustsFontSizeToFitWidth = true
        textColor = .black
    }
}
