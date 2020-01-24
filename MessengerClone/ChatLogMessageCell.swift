//
//  ChatLogMessageCell.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-22.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Message"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        
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
