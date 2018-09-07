//
//  RegisterViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/6/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit
import os.log

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var registerError: UILabel!
    @IBOutlet weak var register: UIButton!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerError.isHidden = true;
        
        name.delegate = self;
        loginUsername.delegate = self;
        loginPassword.delegate = self;
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
    
    //MARK: Actions
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
    
    @IBAction func registerUser(_ sender: UIButton) {
        if (name.text?.isEmpty ?? true || loginUsername.text?.isEmpty ?? true || loginPassword.text?.isEmpty ?? true) {
            registerError.isHidden = false;
            registerError.textColor = UIColor.red;
            registerError.text = "Name, Username or Password missing.";
        } else {
            registerError.isHidden = true;
            
            let name = self.name.text;
            let loginUsername = self.loginUsername.text;
            let loginPassword = self.loginPassword.text;
            let photo = self.photo.image;
            
            print("Storing user data");
            user = User(name: name!, loginUsername: loginUsername!, loginPassword: loginPassword!, photo: photo);
            
            //TODO: Either navigate back to Login page or LoggedIn User Welcome page
            backToLoginController(Sender: register);
        }
    }
}
