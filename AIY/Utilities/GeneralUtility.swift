//
//  GeneralUtility.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/19/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import Foundation
import UIKit

class GeneralUtility {
    
    static func isDouble(_ amount: String) -> Bool {
        if let price = Double(amount) {
            if price >= 0 {
                return true
            }
        }
        return false
    }
}
