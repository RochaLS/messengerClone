//
//  Message+CoreDataProperties.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-20.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var friend: Friend?

}
