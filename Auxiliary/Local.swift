//
//  Local.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Local {
    static func saveSession(session_id: String, user_id: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Session", in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(session_id, forKey: "session_id")
        object.setValue(user_id, forKey: "user_id")
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    static func loadSession() throws -> Bool {
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        
        do {
            //let result = try managedObjectContext.fetch(fetchRequest)
            //print(result)
            return true
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            
            return false
        }*/
        return false
    }
    
}
