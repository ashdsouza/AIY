//
//  ProductTableViewCell.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/17/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var buyersPrice: UILabel!
    @IBOutlet weak var productBidCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
