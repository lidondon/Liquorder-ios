//
//  itemCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/1.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var labQuantity: UILabel!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labCapacity: UILabel!
    @IBOutlet weak var labBottling: UILabel!
    @IBOutlet weak var labPrice: UILabel!
    @IBOutlet weak var ivFavorite: UIImageView!
    @IBOutlet weak var vLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setMenuItem(item: MenuItem) {
        labName.text = item.liquorName
        labCapacity.text = "\(item.liquorCapacity) c.c."
        labBottling.text = item.liquorBottling
        labPrice.text = "$ \(item.price)"
        if item.quantity == nil || item.quantity! == 0 {
            vLine.isHidden = true
            labQuantity.isHidden = true
        } else {
            vLine.isHidden = false
            labQuantity.isHidden = false
            labQuantity.text = "x \(String(describing: item.quantity!)) "
        }
    }
    
}
