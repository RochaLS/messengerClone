//
//  FriendsControllerHelper.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-15.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit
import CoreData

//class Message: NSObject {
//    var text: String?
//    var date: NSDate?
//    
//    var friend: Friend?
//}
//
//class Friend: NSObject {
//    var name: String?
//    var imageName: String?
//}

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                
                // Deleting all data before repopulating it.
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
                
                try context.save()
                
            } catch let error {
                print(error)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let lucas = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            lucas.name = "Lucas Rocha"
            lucas.imageName = "Lucas"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.text = "Whats up?"
            message.date = Date()
            message.friend = lucas
            
            let chloe = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            chloe.name = "Chloe Moretz"
            chloe.imageName = "chloe"
            
            let chloeMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            chloeMessage.text = "Hey!! I'm shooting Kick Ass 3!"
            chloeMessage.friend = chloe
            chloeMessage.date = Date()
            
            
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        
        loadData()
        
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            
            do {
                messages = try context.fetch(fetchRequest) as? [Message]
            } catch let error {
                print(error)
            }
            
            
        }
    }
}
