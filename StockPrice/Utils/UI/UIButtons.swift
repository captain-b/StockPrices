//
//  UIButtons.swift
//  StockPrice
//
//  Created by Babak Rezai on 01/02/2023.
//

import UIKit

class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    private func setStyle() {
        titleLabel?.font = UIFont(name: Font.PTSansRegular.rawValue, size: 18)
        backgroundColor = .systemRed
        titleLabel?.tintColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
