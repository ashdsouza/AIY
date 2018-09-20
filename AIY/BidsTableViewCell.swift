//
//  BidsTableViewCell.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/20/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class BidsTableViewCell: UITableViewCell {

    @IBOutlet weak var bidAmount: UILabel!
    @IBOutlet weak var bidOwner: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
