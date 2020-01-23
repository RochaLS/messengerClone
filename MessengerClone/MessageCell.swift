//
//  MessageCell.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-22.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.darkGray
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            
            if let imgName = message?.friend?.imageName {
                profileImageView.image = UIImage(named: imgName)
                hasReadImageView.image = UIImage(named: imgName)
            }
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = Date().timeIntervalSince(date)
                
                // Time interval is always in seconds
                let secondsInADay: TimeInterval = 60 * 60 * 24 // one day
                
                if elapsedTimeInSeconds > 7 * secondsInADay {
                    dateFormatter.dateFormat = "dd/MM/yy"
                } else if  elapsedTimeInSeconds > secondsInADay {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return dividerView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Lucas Rocha"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, how are you?"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:58pm"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        profileImageView.image = UIImage(named: "Lucas" )
        hasReadImageView.image = UIImage(named: "Lucas" )
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        
        //Setting constrains using Visual Format Language
        // H = Horizontal V = Vertical, width or height inside ()
        // | = Edges of the screen
        
        
        addContraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addContraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        
        // To center a view. Note: view to center Vertically doesn't have || on the visual format string
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addContraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addContraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let container = UIView()
        addSubview(container)
        
        container.addSubview(nameLabel)
        container.addSubview(messageLabel)
        container.addSubview(timeLabel)
        container.addSubview(hasReadImageView)
        
        addContraintsWithFormat(format: "H:|-90-[v0]|", views: container)
        addContraintsWithFormat(format: "V:[v0(50)]", views: container)
        
        addContraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        addContraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        addContraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        addContraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        addContraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
        
        // Center container
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
