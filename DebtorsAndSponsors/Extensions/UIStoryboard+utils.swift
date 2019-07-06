//
//  UIStoryboard+utils.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 5/25/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

extension UIStoryboard {
    public static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    public func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let viewController = instantiateViewController(withIdentifier: storyboardID) as? T {
            return viewController
        } else {
            return nil
        }
    }
}
