//
//  AddBidViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/19/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class AddBidViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var productTitleToBid: UILabel!
    @IBOutlet weak var invalidPriceError: UILabel!
    @IBOutlet weak var bidAmount: UITextField!
    @IBOutlet weak var additionalComments: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var product: Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        invalidPriceError.textColor = UIColor.red
        invalidPriceError.isHidden = true
        additionalComments.text = "Additional Comments"
        additionalComments.textColor = UIColor.lightGray
        
        bidAmount.delegate = self
        additionalComments.delegate = self
        
        guard let price = product?.buyPrice else {
            return
        }
        productTitleToBid.text = "Bid for " + (product?.title)! + " wanted for $" + String(price)
        
        updateSaveButtonState()
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Additional Comments"
            textView.textColor = UIColor.lightGray
        }
    }
    
    private func updateSaveButtonState() {
        if bidAmount.text?.isEmpty ?? true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func saveBidInDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let bid = Bids(context: context)
        bid.addComments = additionalComments.text
        guard let price = bidAmount.text else {
            return
        }
        bid.price = Double(price)!
        guard let uname = UserDefaults.standard.string(forKey: "userName") else {
            return
        }
        bid.owner = uname
        
        //add bids to products as part of relationship
        product?.addToBids(bid)
        
        appDelegate.saveContext()
    }
    
    @IBAction func saveBid(_ sender: UIBarButtonItem) {
        updateSaveButtonState()
        
        //validate if price is valid
        if GeneralUtility.isDouble(bidAmount.text!) {
            invalidPriceError.isHidden = true
            saveBidInDB()
            dismiss(animated: true, completion: nil)
        } else {
            invalidPriceError.isHidden = false
            invalidPriceError.text = "Price is not valid."
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
