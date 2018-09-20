//
//  CoreDataUtility.swift
//  AIY
//
//  Created by Ashley F Dsouza on 9/13/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataUtility {
    
    static func checkIfRegistered(_ uname: String, _ pass: String) -> [Users] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "loginUsername = %@ and loginPassword = %@", uname, pass)
        request.returnsObjectsAsFaults = false
        do {
            print("Fetching from DB")
            let result = try context.fetch(request) as! [Users]
            return result
        } catch {
            print("Failed to fetch")
            let nserror = error as NSError
            fatalError("Failed to fetch user \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func loadProducts(_ owner: String) -> [Products] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        request.predicate = NSPredicate(format: "owner = %@", owner)
        request.returnsObjectsAsFaults = false
        request.relationshipKeyPathsForPrefetching = ["bids"]
        do {
            print("Fetching from DB")
            let result = try context.fetch(request) as! [Products]
            return result
        } catch {
            print("Failed to fetch")
            let nserror = error as NSError
            fatalError("Failed to fetch user \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func getUserInfo(_ loginName: String) -> Users {
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
    
    static func getDataFromDB(_ entityName: String) -> [Any] {
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
    
    static func getPhoto(_ photo: NSData, _ width: CGFloat) -> UIImage {
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
    
    static func getProductsInCategory(_ category: String) -> [Products] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        request.predicate = NSPredicate(format: "category = %@", category)
        request.returnsObjectsAsFaults = false
        request.relationshipKeyPathsForPrefetching = ["bids"]
        do {
            print("Fetching from DB")
            let result = try context.fetch(request) as! [Products]
            return result
        } catch {
            print("Failed to fetch")
            let nserror = error as NSError
            fatalError("Failed to fetch user \(nserror), \(nserror.userInfo)")
        }
    }
}
