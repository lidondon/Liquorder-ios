//
//  CategoryCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/28.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var labName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCategory(category: Category) {
        labName.text = category.name
    }
}
