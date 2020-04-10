//
//  CellarerEasyCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/16.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class CellarerEasyCell: UICollectionViewCell {
    @IBOutlet weak var labName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellarer(cellarer: Cellarer) {
        labName.text = cellarer.name
    }
}
