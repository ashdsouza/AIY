//
//  WelcomeViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/7/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var registeredUser: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var addProductButton: UIButton!
    
    @IBOutlet weak var productTable: UITableView!
    var products = [Products]()
    var indexOfSelectedProduct: Int?
    
    //pull to refresh table
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshBidCount(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTable.delegate = self
        productTable.dataSource = self

        // Do any additional setup after loading the view.
        self.productTable.addSubview(self.refreshControl)
        
        guard let userNameSes = UserDefaults.standard.string(forKey: "userName") else {
            print("Unable to get username from session")
            return
        }
        
        let user: Users = CoreDataUtility.getUserInfo(userNameSes)
        let profileImage: UIImage = CoreDataUtility.getPhoto(user.photo!, 50)
        registeredUser.text = user.name
        profilePhoto.image = profileImage
        
        //Display "Add Product" button only if Buyer
        //if Buyer then load all products added by that buyer
        //if Seller then load all products in the Seller's category
        let prods: [Products]
        if(user.type) {
            addProductButton.isHidden = true
            prods = CoreDataUtility.getProductsInCategory(user.category!)
        } else {
            addProductButton.isHidden = false
            prods = CoreDataUtility.loadProducts(userNameSes)
        }
        
        if prods.count > 0 {
            products = prods
        } else {
            productTable.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func refreshBidCount(_ refreshControl: UIRefreshControl) {
        self.productTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productTable.isHidden = false
        guard let cell = productTable.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProductTableViewCell.")
        }
        let prod = products[indexPath.row]
        cell.productTitle.text = prod.title
        cell.buyersPrice.text = "$" + String(prod.buyPrice)
        if (prod.photo != nil) {
            cell.productImage.image = CoreDataUtility.getPhoto(prod.photo!, 100)
        }
        //TODO: Get bids for product and set the count here
        let set = prod.bids
        //TODO: Arrange bids based on different Seller comments or pricing
        var bids = [Bids]()
        bids = set?.allObjects as! [Bids]
        cell.productBidCount.text = "Bids = " + String(bids.count)
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //this segue is called when a row is selected to get more Product Details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetail" {
            
            let indexPath = productTable.indexPathForSelectedRow
            let index = indexPath?.row
            
            print("Row \(index) selected")
            print("Title \(products[index!].title)")
            print("Cost \(products[index!].buyPrice)")
            print("Cost \(products[index!].desc)")
            
            let nvc = segue.destination as! UINavigationController
            let svc = nvc.topViewController as! ProductDetailsViewController
            svc.productSelected = products[index!]
        }
    }
    
    @IBAction func unwindToProductList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddProductViewController, let product = sourceViewController.productAdded {
            let newIndexPath = IndexPath(row: products.count, section: 0)
            
            products.append(product)
            productTable.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
