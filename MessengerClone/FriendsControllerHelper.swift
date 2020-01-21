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
            
            let barry = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            barry.name = "Barry Allen"
            barry.imageName = "barry"
            
            let tony = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            tony.name = "Tony Stark"
            tony.imageName = "tony"
            
            createSteveMessagesWithContext(context: context)
            
            
            createMessageWithText(text: "I'm Iron Man", friend: tony, minutesAgo: 24 * 60, context: context)
            
            createMessageWithText(text: "My name is Barry Allen and I'm the...", friend: barry, minutesAgo: 5, context: context)
            createMessageWithText(text: "Hey, how are you?", friend: chloe, minutesAgo: 3, context: context)
            createMessageWithText(text: "I'm Chloe!", friend: chloe, minutesAgo: 2, context: context)
            createMessageWithText(text: "Kicking ass!", friend: chloe, minutesAgo: 1, context: context)
            
            
            
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        
        
        loadData()
        
    }
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
                   steve.name = "Steve Rogers"
                   steve.imageName = "steve"
        createMessageWithText(text: "Lorem ipsum dolor sit amet.", friend: steve, minutesAgo: 8 * 60 * 24, context: context)
        createMessageWithText(text: "Hello, I hope you are very well! Do you want to hangout?", friend: steve, minutesAgo: 8 * 60 * 24, context: context)
        createMessageWithText(text: "We are gonna go Ice Skating somewhere in downtown, let me know if you wanna go! We are waiting for you.", friend: steve, minutesAgo: 8 * 60 * 24, context: context)
        createMessageWithText(text: "Yes sure! What time?", friend: steve, minutesAgo: 2, context: context, isSender: true)
        createMessageWithText(text: "At 8:00pm", friend: steve, minutesAgo: 5, context: context)
        createMessageWithText(text: "Okay I'm going!", friend: steve, minutesAgo: 3, context: context, isSender: true)
        createMessageWithText(text: "Can you send me the address? I will be leaving my house at 7:00! I will meet you at the Avengers tower!", friend: steve, minutesAgo: 2, context: context, isSender: true)
        
        createMessageWithText(text: "Leaving now!", friend: steve, minutesAgo: 0, context: context, isSender: true)
        
        createMessageWithText(text: "Okay!", friend: steve, minutesAgo: 0, context: context)
    }
    
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.friend = friend
        message.date = Date().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender // isSender is the person who is "answering" the message
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchedMessages = try context.fetch(fetchRequest) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    } catch let error {
                        print(error)
                    }
                    
                }
                
                messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            }
            
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                return try context.fetch(fetchRequest) as? [Friend]
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}
