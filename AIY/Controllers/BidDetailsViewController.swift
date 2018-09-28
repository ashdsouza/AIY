//
//  BidDetailsViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/24/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class BidDetailsViewController: UIViewController {

    @IBOutlet weak var bidAmount: UILabel!
    @IBOutlet weak var sellerComments: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var bidSelected: Bids?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //show buy button only if Buyer
        let userType = UserDefaults.standard.bool(forKey: "userType")
        if userType {
            buyButton.isHidden = true
        } else {
            buyButton.isHidden = false
        }
        
        guard let amount = bidSelected?.price else {
            return
        }
        bidAmount.text = "$" + String(amount)
        if bidSelected?.addComments?.isEmpty ?? true {
            sellerComments.text = "No Additional Comments"
        }
        sellerComments.text = bidSelected?.addComments
        
        //TODO: If bid belongs to the seller who is in session, it should be editable
        //Owner of the bid should be able to edit bid by looking at other seller offerings
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSellerProfile" {
            let svc = segue.destination as! SellerProfileViewController
            svc.sellerUname = bidSelected?.owner
        } else if segue.identifier == "ShowSellerReview" {
            let nc = segue.destination as! UINavigationController
            let svc = nc.topViewController as! RatingViewController
            svc.seller = bidSelected?.owner
        }
    }

}
