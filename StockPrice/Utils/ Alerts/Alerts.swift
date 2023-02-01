//
//  Alerts.swift
//  StockPrice
//
//  Created by Babak Rezai on 01/02/2023.
//

import UIKit

public func displayMessage(vc: UIViewController, message: String) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        vc.present(alertController, animated: true, completion: nil)
    }
}
