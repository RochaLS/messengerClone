//
//  ViewController.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-10.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit
import CoreData




class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate{
    
    private let cell_id = "cell_id"
    
    //Getting Friends
    lazy var fetchedResultsController: NSFetchedResultsController<Friend> = {
        let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Simulates when the user adds a new friend
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(simulateAddFriend))
        collectionView?.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cell_id)
        
        navigationItem.title = "Recents"
        
        
        setupData()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error)
        }
        

    }
    
    @objc func simulateAddFriend() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lucas = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        lucas.name = "Lucas Rocha"
        lucas.imageName = "Lucas"
        FriendsController.createMessageWithText(text: "What's up?", friend: lucas, minutesAgo: 0, context: context)
    }
    
    //MARK: - Managing and Listening to Object changes
    
    
    var blockOperations = [BlockOperation]()
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
                print(self.blockOperations.count)
            }))
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        })
    }
    
    //MARK: - CollectionView Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_id, for: indexPath) as! MessageCell
        
        let friend = fetchedResultsController.object(at: indexPath)
        cell.message = friend.lastMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        let friend = fetchedResultsController.object(at: indexPath)
        controller.friend = friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

// Creating this extension to simplify when adding constrains with visual format
extension UIView {
    func addContraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String:UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Better to write code below just once ;)
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .init(), metrics: nil, views: viewsDictionary))
        
        
    }
}
