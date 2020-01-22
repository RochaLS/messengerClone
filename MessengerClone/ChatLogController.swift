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
    
    var bottomConstraint: NSLayoutConstraint?
    
    var inputContainerHeightContrainst: NSLayoutConstraint?
    
    var messages: [Message]?
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages?.sort(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    
    let containerInputView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        return textField
    }()
    
   lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSendButton() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = delegate.persistentContainer.viewContext
        
        let message = FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 1, context: context, isSender: true)
        
        do {
            try context.save()
            
            messages?.append(message)
            
            let indexPath = NSIndexPath(item: messages!.count - 1, section: 0)
            
            
            collectionView.insertItems(at: [(indexPath as IndexPath)])
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            inputTextField.text = nil
        } catch let error {
            print(error)
        }
        
        
        
        
    }
    
    let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    @objc func simulateReceiveMessage() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
               
        let context = delegate.persistentContainer.viewContext
        
        let message = FriendsController.createMessageWithText(text: "Let's goooo!", friend: friend!, minutesAgo: 0, context: context , isSender: false)
        
        do {
            try context.save()
            
            messages?.append(message)
            
            messages?.sort(by: {$0.date!.compare($1.date!) == .orderedAscending})
            
            if let item = messages?.firstIndex(of: message) {
                let indexPath = NSIndexPath(item: item, section: 0)
                collectionView.insertItems(at: [(indexPath as IndexPath)])
                collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
            
           
//
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate msg", style: .plain, target: self, action: #selector(simulateReceiveMessage))
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cell_id)
        
        
        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(containerInputView)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: containerInputView)
        
        bottomConstraint = NSLayoutConstraint(item: containerInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        // Height of the inputContainer will change depending if the device has notch or not
        if UIDevice.current.hasNotch {
             inputContainerHeightContrainst = NSLayoutConstraint(item: containerInputView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 48 + 34)
        } else {
            inputContainerHeightContrainst = NSLayoutConstraint(item: containerInputView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 48)
        }
        
         
        view.addConstraint(inputContainerHeightContrainst!)
        
        view.addConstraint(bottomConstraint!)
        
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48 + 17, right: 0) // Using this to prevent text field of overlapping last message of the collection view 48 is the height of the whole text field container, and plus 17 for a little bit of more spacing.
        
        
    }
    
    private func setupInputComponents() {
        containerInputView.addSubview(inputTextField)
        containerInputView.addSubview(sendButton)
        containerInputView.addSubview(topLineView)
        containerInputView.addContraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        containerInputView.addContraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        containerInputView.addContraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        containerInputView.addContraintsWithFormat(format: "H:|[v0]|", views: topLineView)
        containerInputView.addContraintsWithFormat(format: "V:|[v0(0.5)]", views: topLineView)
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            let keyboardHeight = keyboardFrame?.cgRectValue.height
            
            //keyboardFrame?.cgRectValue.height = keyboardFrame?.cgRectValue.height+100
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight! : 0
            
            if UIDevice.current.hasNotch {
                 inputContainerHeightContrainst?.constant = isKeyboardShowing ? 48 : 48 + 34
            } else {
                inputContainerHeightContrainst?.constant = 48
            }
           
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }) { (completed) in
                
                if isKeyboardShowing {
                    let indexPath = NSIndexPath(row: self.messages!.count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
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
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = messages?[indexPath.item].friend?.imageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //Calculate the size of the message bubble based on the text
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !message.isSender {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 15)
                
                cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 15)
                
                cell.messageTextView.textColor = UIColor.black
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                
                cell.profileImageView.isHidden = false
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 15)
                
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 15)
                
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                
                cell.messageTextView.textColor = UIColor.white
                
                cell.profileImageView.isHidden = true
                
            }
            
            
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //Calculate the size of the message bubble based on the text
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0) // Giving distance from the top
    }
    
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Message"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        
        return textView
    }()
    
    let textBubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        bubbleView.layer.cornerRadius = 15
        bubbleView.layer.masksToBounds = true
        return bubbleView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addContraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addContraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
    }
    
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
