//
//  RegisterViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/6/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit
import os.log
import CoreData

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var registerError: UILabel!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var buyerSellerSwitch: UISwitch!
    @IBOutlet weak var category: UIPickerView!
    
    var categories = [String]()
    var userType: Bool!
    var categoryNameSelected: String! = nil
    let imagePicker = UIImagePickerController()
    
//    var appDelegate: AppDelegate!
//    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerError.isHidden = true;
        buyerSellerSwitch.isOn = false;
        toggleSwitch()
        
//        appDelegate = UIApplication.shared.delegate as! AppDelegate;
//        context = appDelegate.persistentContainer.viewContext
        
        //triggers the sellerSelected function when the switch is toggeled
        buyerSellerSwitch.addTarget(self, action: #selector(sellerSelected(_:)), for: UIControlEvents.valueChanged)
        
        name.delegate = self;
        loginUsername.delegate = self;
        loginPassword.delegate = self;
        category.delegate = self;
        category.dataSource = self;
        imagePicker.delegate = self;
        
        //TODO: Fill Data in Category Table so it can show up here
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let cat = Category(context: context);
//        cat.name = "Items";
//        
//        appDelegate.saveContext()
//        
//        let cat2 = Category(context: context);
//        cat2.name = "Cars";
//        
//        appDelegate.saveContext()
//        
//        let cat3 = Category(context: context);
//        cat3.name = "Houses";
//        
//        appDelegate.saveContext()
        
        
        let result = getDataFromDB("Category")
        for data in result as! [NSManagedObject] {
            print(data.value(forKey: "name") as! String)
            categories.append(data.value(forKey: "name") as! String)
        }
//        categories.append("Items")
//        categories.append("Car")
//        categories.append("Houses")
        
        //TODO: Unless picker is toggeled, category is not selected. Fix this.
        //set default as "Cars" for now
        category.selectRow(1, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender);
    }
    
    func toggleSwitch() {
        if buyerSellerSwitch.isOn {
            print("Seller Selected display category picker");
            category.isHidden = false;
            userType = true;
        } else {
            print("It is a Buyer. Hide category picker");
            category.isHidden = true;
            userType = false;
        }
    }
    
    func getDataFromDB(_ entityName: String) -> [Any] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
        request.returnsObjectsAsFaults = false
        do {
            print("Fetching from DB")
            let result = try context.fetch(request)
            return result
        } catch {
            print("Failed to fetch")
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK: Actions
    //display the category of seller selection if it is seller
    @IBAction func sellerSelected(_ sender: UISwitch) {
        toggleSwitch()
    }
    
    //Lets user pick an image from the photo library
    @IBAction func selectPhotoFromLibrary(_ sender: Any) {
        //Hide keyboard if image is tapped
        name.resignFirstResponder();
        
        //lets user pick media from their photo library
        let photoPickerController = UIImagePickerController();
        //only allows photos to be picked, not taken
        photoPickerController.sourceType = .photoLibrary;
        //View controller is notified when user picks an image
        photoPickerController.delegate = self;
        present(photoPickerController, animated: true, completion: nil);
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
        categoryNameSelected = categories[row] as String
    }
    
    //MARK: Functions for Image Picker
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
        photo.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    //function to navigate to Login page after registration is complete
    func backToLoginController(Sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let loginController = storyBoard.instantiateViewController(withIdentifier: "loginController") as! ViewController
        self.present(loginController, animated: true, completion: nil)
    }
    
    func storeUserData(_ photo: Data) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = Users(context: context);
        newUser.name = self.name.text;
        newUser.loginUsername = self.loginUsername.text;
        newUser.loginPassword = self.loginPassword.text;
        newUser.photo = photo as NSData?;
        newUser.type = userType;
        newUser.category = categoryNameSelected;
        
        appDelegate.saveContext();
        
        //retrieve data
//        let result = getDataFromDB("Users")
//        for data in result as! [NSManagedObject] {
//            print(data.value(forKey: "name") as! String)
//            print(data.value(forKey: "loginUsername") as! String)
//            print(data.value(forKey: "loginPassword") as! String)
//            print(data.value(forKey: "type") as! Bool)
//            guard let cat = data.value(forKey: "category") else {
//                print("Nothing set for category")
//                continue
//            }
//            print(cat)
//        }
        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users");
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            print("Trying to fetch")
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "name") as! String)
//                print(data.value(forKey: "loginUsername") as! String)
//                print(data.value(forKey: "loginPassword") as! String)
//                if let rPhoto = data.value(forKey: "photo") {
//                    print(data.value(forKey: "photo") as! NSData);
//                } else {
//                    print("  No photo for this user");
//                }
//            }
//        } catch {
//            print("Failed")
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        if (name.text?.isEmpty ?? true || loginUsername.text?.isEmpty ?? true || loginPassword.text?.isEmpty ?? true) {
            registerError.isHidden = false;
            registerError.textColor = UIColor.red;
            registerError.text = "Name, Username or Password missing.";
        } else {
            registerError.isHidden = true;
            
            guard let photo = UIImagePNGRepresentation(self.photo.image!) else {
                print("Failed to convert PNG image")
                return
            }
            
            //store data in DB
            storeUserData(photo);

            //navigate to LoggedIn User Welcome page
            //TODO: call function in LoginController
            let storyBoard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil);
            let welcomeController = storyBoard.instantiateViewController(withIdentifier: "welcomeController") as! WelcomeViewController
            
            welcomeController.userName = self.loginUsername.text!;
            self.present(welcomeController, animated: true, completion: nil)
        }
    }
}
