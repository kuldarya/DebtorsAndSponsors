//
//  UIAlertController+Utils.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 7/9/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showAlert(title: String, message: String, controller: UIViewController, actionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            actionHandler?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
