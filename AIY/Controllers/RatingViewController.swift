//
//  RatingViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/27/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviews: UITextView!
    var seller: String?
    var user: Users?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = CoreDataUtility.getUserInfo(seller!)
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
    
    @IBAction func saveReview(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let review = Ratings(context: context)
        guard let ratingVal = ratingControl?.rating else {
            return
        }
        review.outOf5 = Int32(ratingVal)
        guard let reviewsVal = reviews.text else {
            return
        }
        review.review = reviewsVal
        
        //Associate review with Seller
        user?.addToRatings(review)
        
        appDelegate.saveContext()
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
