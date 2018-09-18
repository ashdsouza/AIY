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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let userNameSes = UserDefaults.standard.string(forKey: "userName") else {
            print("Unable to get username from session")
            return
        }
        
        let user: Users = CoreDataUtility.getUserInfo(userNameSes)
//        print(user.name as String?)
//        print(user.type as Bool?)
//        print(user.category as String?)
        let profileImage: UIImage = getPhoto(user.photo!, 50)
        registeredUser.text = user.name
        profilePhoto.image = profileImage
        
        //Display "Add Product" button only if Buyer
        if(user.type) {
            addProductButton.isHidden = true
        } else {
            addProductButton.isHidden = false
        }
        
        //load all products for that user, if not products then hide the table view
        let prods: [Products] = CoreDataUtility.loadProducts(userNameSes)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productTable.isHidden = false
        guard let cell = productTable.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProductTableViewCell.")
        }
        let prod = products[indexPath.row]
        cell.productTitle.text = prod.title
        cell.buyersPrice.text = String(prod.buyPrice)
        if (prod.photo != nil) {
            cell.productImage.image = getPhoto(prod.photo!, 100)
        }
        //TODO: Get bids for product and set the count here
        cell.productBidCount.text = String(0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
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
    
    //Get user profile picture and resize it to display in 50x50
    func getPhoto(_ photo: NSData, _ width: CGFloat) -> UIImage {
        let pic: UIImage = UIImage(data: photo as Data)!
        
        //Resizing logic
        let newWidth: CGFloat = width;
        let scale = newWidth / pic.size.width
        let newHeight = pic.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        pic.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
