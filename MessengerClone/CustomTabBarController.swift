//
//  CustomTabBarController.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-17.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup some custom view controllers
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [recentMessagesNavController]
        
        
        
    }
    
}
