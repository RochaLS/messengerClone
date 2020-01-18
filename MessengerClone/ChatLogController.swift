//
//  ChatLogController.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-15.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cell_id = "cell_id"
    
    var messages: [Message]?
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages?.sort(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cell_id)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            print(count)
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_id, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Message"
        textView.font = UIFont.systemFont(ofSize: 16)
        
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(messageTextView)
        
        addContraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
         addContraintsWithFormat(format: "V:|[v0]|", views: messageTextView)

    }
    
}
