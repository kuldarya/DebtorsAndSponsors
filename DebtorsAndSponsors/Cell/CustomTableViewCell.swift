//
//  CustomTableViewCell.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 5/23/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
