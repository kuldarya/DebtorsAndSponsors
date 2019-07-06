//
//  DetailsViewController.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 5/22/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet private weak var refundDetailsLabel: UILabel!
    
    var refunds = [Refund]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refundDetailsLabel.text = refunds.map { $0.description }.joined(separator: "\n")
    }
}
