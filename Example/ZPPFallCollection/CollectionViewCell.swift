//
//  CollectionViewCell.swift
//  ZPPProduct
//
//  Created by admin on 2020/11/27.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var model: ZPPModel = ZPPModel(dic: [String : Any]()){
        didSet {
            nickNameLabel.text = model.nickName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
