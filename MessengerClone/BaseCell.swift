//
//  BaseCell.swift
//  MessengerClone
//
//  Created by Lucas Rocha on 2020-01-22.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
//
        
    }
}
