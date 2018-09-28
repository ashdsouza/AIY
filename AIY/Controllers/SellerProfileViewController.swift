//
//  SellerProfileViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/25/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class SellerProfileViewController: UIViewController {//, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingStars: UILabel!
    
    
    @IBOutlet weak var previousSalesTable: UITableView!
    var sellerUname: String?
    var seller: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        previousSalesTable.dataSource = self
//        previousSalesTable.delegate = self

        // Do any additional setup after loading the view.
        seller = CoreDataUtility.getUserInfo(sellerUname!)
        profilePic.image = CoreDataUtility.getPhoto((seller?.photo)!, 100)
        name.text = seller?.name
        category.text = seller?.category
        
        //TODO: Fill these informations from Ratings Table
        reviewCount.text = String(0)
        ratingStars.text = "NO RATINGS YET"
        
        //remove extra separators from table if few rows to show
        previousSalesTable.tableFooterView = UIView(frame: .zero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //Return 1 if there are bids available to show
//        //Else show "No Bids Available" in place of table data
//        var numOfSections: Int = 0
////        if sales.count > 0 {
////            self.previousSalesTable.backgroundView = nil
////            numOfSections = 1
////        } else {
//            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.previousSalesTable.bounds.size.width, height: self.previousSalesTable.bounds.size.height))
//            noDataLabel.text = "No Sales made"
//            noDataLabel.textColor = UIColor.black
//            noDataLabel.textAlignment = NSTextAlignment.center
//            self.previousSalesTable.backgroundView = noDataLabel
////        }
//        return numOfSections
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
////        return allBids.count
//        return 1
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
