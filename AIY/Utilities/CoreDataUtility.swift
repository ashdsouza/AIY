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
}
