//
//  CartItemCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/10.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    @IBOutlet weak var labQuantity: UILabel!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labCapacity: UILabel!
    @IBOutlet weak var labPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: OrderItem) {
        labQuantity.text = "\(item.quantity) x"
        labName.text = item.liquorName
        labCapacity.text = "\(item.liquorCapacity) c.c."
        labPrice.text = "$ \(item.price)"
    }
}
