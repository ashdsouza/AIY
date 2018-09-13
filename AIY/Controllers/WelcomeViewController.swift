//
//  WelcomeViewController.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/7/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var registeredUser: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    var userName = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user: Users = getUserInfo(userName)
//        print(user.name as String?)
//        print(user.type as Bool?)
//        print(user.category as String?)
        let profileImage: UIImage = getUserPhoto(user.photo!)
        registeredUser.text = user.name
        profilePhoto.image = profileImage
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
    
    //fetch user after registration
    func getUserInfo(_ loginName: String) -> Users {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "loginUsername = %@", loginName)
        request.returnsObjectsAsFaults = false
        do {
            print("Fetching from DB")
            let result = try context.fetch(request) as! [Users]
            return result[0]
        } catch {
            print("Failed to fetch")
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //Get user profile picture and resize it to display in 50x50
    func getUserPhoto(_ photo: NSData) -> UIImage {
        let pic: UIImage = UIImage(data: photo as Data)!
        
        //Resizing logic
        let newWidth: CGFloat = 50;
        let scale = newWidth / pic.size.width
        let newHeight = pic.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        pic.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
