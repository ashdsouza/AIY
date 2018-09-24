//
//  BidsTableViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/20/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class BidsTableViewController: UITableViewController {

    @IBOutlet var bidsTableView: UITableView!
    var allBids = [Bids]()
    
    //pull to refresh table
    lazy var refreshController: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshBids(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.bidsTableView.addSubview(self.refreshController)
        
        //remove extra separators from table if few rows to show
        bidsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func refreshBids(_ refreshControl: UIRefreshControl) {
        self.bidsTableView.reloadData()
        refreshController.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //Return 1 if there are bids available to show 
        //Else show "No Bids Available" in place of table data
        var numOfSections: Int = 0
        if allBids.count > 0 {
            self.bidsTableView.backgroundView = nil
            numOfSections = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bidsTableView.bounds.size.width, height: self.bidsTableView.bounds.size.height))
            noDataLabel.text = "No Bids Available"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.bidsTableView.backgroundView = noDataLabel
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allBids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bidsTableView.dequeueReusableCell(withIdentifier: "BidsTableViewCell", for: indexPath) as? BidsTableViewCell else {
            fatalError("The dequeued cell is not an instance of BidsTableViewCell.")
        }
        let bid = allBids[indexPath.row]
        cell.bidAmount.text = "$" + String(bid.price)
        
        let seller = CoreDataUtility.getUserInfo(bid.owner!)
        
        cell.bidOwner.text = seller.name
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = UIColor.black
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBidDetail" {
            
            let indexPath = bidsTableView.indexPathForSelectedRow
            let index = indexPath?.row
            
            let nvc = segue.destination as! BidDetailsViewController
            nvc.bidSelected = allBids[index!]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
