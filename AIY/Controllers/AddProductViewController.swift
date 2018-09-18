//
//  AddProductViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/14/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import os.log

class AddProductViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UITextField!
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productBuyPrice: UITextField!
    @IBOutlet weak var invalidPriceError: UILabel!
    @IBOutlet weak var productCategory: UIPickerView!
    @IBOutlet weak var saveProduct: UIBarButtonItem!
    
    var categories = [String]()
    var categorySelected: String? = nil
    var price: Double?
    
    var productAdded: Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        invalidPriceError.textColor = UIColor.red
        invalidPriceError.isHidden = true
        productDesc.text = "Description"
        productDesc.textColor = UIColor.lightGray
        
        productTitle.delegate = self
        productDesc.delegate = self
        productBuyPrice.delegate = self
        productCategory.delegate = self
        
        //get categories
        let result = CoreDataUtility.getDataFromDB("Category")
        for data in result as! [NSManagedObject] {
            print(data.value(forKey: "name") as! String)
            categories.append(data.value(forKey: "name") as! String)
        }
        //set default as "Cars" for now
        productCategory.selectRow(1, inComponent: 0, animated: false)
        
        updateSaveButtonState()
        
        //TODO: Show clearer UIPicker View just like in Register page.
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
    @IBAction func selectProductPicFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        productTitle.resignFirstResponder()
        let imagePicCtrl = UIImagePickerController()
        imagePicCtrl.sourceType = .photoLibrary
        imagePicCtrl.delegate = self
        present(imagePicCtrl, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil);
    }
    
    //sets the photo on the profile to the image picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //use the original representaion of image from the info library
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //set photo to display the selected image
        productImage.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    //MARK: Functions for Category Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = categories[row] as String
    }
    
    //MARK: TextView and TextField Delegate functions
    //TODO: After adding text in view and field, tapping outside should trigger updateSaveButtonState()
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    private func updateSaveButtonState() {
        if(productTitle.text?.isEmpty ?? true || productDesc.text?.isEmpty ?? true || productBuyPrice.text?.isEmpty ?? true) {
            saveProduct.isEnabled = false
        } else {
            saveProduct.isEnabled = true
        }
    }
    
    //this function is called to validate before segue actually navigates
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //validate that price is a number
        if isDouble() {
            invalidPriceError.isHidden = true
            return true
        } else {
            invalidPriceError.isHidden = false
            invalidPriceError.text = "Price is not valid."
            saveProduct.isEnabled = false
            return false
        }
    }
    
    //this menthod connects the segue back to WelcomeViewController with new product added
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveProduct else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type:.debug)
            return
        }
        
        price = Double(self.productBuyPrice.text!)
            
        guard let photo = UIImagePNGRepresentation(self.productImage.image!) else {
            print("Failed to convert PNG image")
            return
        }
            
        addProductToDB(photo)
    }
    
    func isDouble() -> Bool {
        if let price = Double(self.productBuyPrice.text!) {
            if price >= 0 {
                return true
            }
        }
        return false
    }
    
    func addProductToDB(_ photo: Data) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let product = Products(context: context)
        product.title = self.productTitle.text
        product.buyPrice = price!
        product.category = categorySelected
        product.desc = self.productDesc.text
        product.photo = photo as NSData?
        //Get user and add as product owner
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            print("Unable to get username from session")
            return
        }
        print("Username is \(userName)")
        product.owner = userName
        
        productAdded = product          //for segue
        
        appDelegate.saveContext()
    }
    
    //when cancel is clicked
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
