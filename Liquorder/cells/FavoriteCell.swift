//
//  FavoriteCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/24.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var ivSmile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setItem(item: LiquorItem) {
        labName.text = item.name
        if let _ = item.favoriteId {
            ivSmile.isHidden = false
        } else {
            ivSmile.isHidden = true
        }
    }
}
