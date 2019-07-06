//
//  Refund.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 5/22/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

struct Refund {
    let who: Friend
    let toWhom: Friend
    let amount: Float
    
    var description: String {
        return who.name + " owes " + "\(amount) byn " + "to " + toWhom.name
    }
}
