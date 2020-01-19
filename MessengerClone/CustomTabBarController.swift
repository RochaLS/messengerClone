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
        
        viewControllers = [recentMessagesNavController, createDummyNavControllerWithTitle(title: "Calls", imgName: "calls"), createDummyNavControllerWithTitle(title: "Groups", imgName: "groups"), createDummyNavControllerWithTitle(title: "People", imgName: "people"), createDummyNavControllerWithTitle(title: "Settings", imgName: "settings")]
        
        
        
    }
    
    private func createDummyNavControllerWithTitle(title: String, imgName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imgName)
        
        return navController
    }
}
