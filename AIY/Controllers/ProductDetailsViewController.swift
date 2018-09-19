//
//  ProductDetailsViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/18/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var makeBidButton: UIButton!
    
    var productSelected: Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productTitle.text = productSelected?.title
        guard let price = productSelected?.buyPrice else {
            return
        }
        productPrice.text = "$" + String(price)
        productDesc.text = productSelected?.desc
        productImage.image = CoreDataUtility.getPhoto((productSelected?.photo)!, 150)
        
        if UserDefaults.standard.bool(forKey: "userType") {
            makeBidButton.isHidden = false
        } else {
            makeBidButton.isHidden = true
        }
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
    @IBAction func backToProductList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
