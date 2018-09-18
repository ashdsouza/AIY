//
//  ViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/4/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginError: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginError.isHidden = true;
        
        //Handle text field's user input throught delegate callbacks
        username.delegate = self;
        password.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        print("What is this");
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Not sure..");
    }
    
    //TODO: Move this function to a Utility class
    //function to navigate to Welcome page after successful login is complete
    func navigateToWelcomeController(Sender: UIButton!, _ nameTest: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let welcomeController = storyBoard.instantiateViewController(withIdentifier: "welcomeController") as! WelcomeViewController
        
        self.present(welcomeController, animated: true, completion: nil)
    }
    
    func saveSessionData(_ uname: String) {
        UserDefaults.standard.set(uname, forKey: "userName")
    }
    
    //MARK: Actions
    @IBAction func loginUser(_ sender: UIButton) {
        loginError.textColor = UIColor.red;
        
        //Check if both fields are empty, either username or password is empty
        if((username.text?.isEmpty ?? true) && (password.text?.isEmpty ?? true)) {
            loginError.isHidden = false;
            loginError.text = "Please enter valid credentials.";
        } else if (username.text?.isEmpty ?? true) {
            loginError.isHidden = false;
            loginError.text = "Please enter username.";
        } else if (password.text?.isEmpty ?? true) {
            loginError.isHidden = false;
            loginError.text = "Please enter password.";
        } else {
            //Logic to check if the user is registered
            guard let uname = username.text else {
                return
            }
            guard let pass = password.text else {
                return
            }
            
            let user: [Users] = CoreDataUtility.checkIfRegistered(uname, pass)
            if user.count > 0 {
                loginError.isHidden = true;
                
                //save data in session
                saveSessionData(uname)
                
                navigateToWelcomeController(Sender: loginButton, uname);
            } else {
                loginError.isHidden = false;
                loginError.text = "User not registered.";
            }
        }
    }
}

