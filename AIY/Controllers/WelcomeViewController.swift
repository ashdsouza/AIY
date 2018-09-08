//
//  WelcomeViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/7/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var registeredUser: UILabel!
    var userName = "";
    
    override func viewDidLoad() {
//        registeredUser.text = "";
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registeredUser.text = userName;
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

}
