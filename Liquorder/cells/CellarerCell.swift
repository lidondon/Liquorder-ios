//
//  CellarerCellTableViewCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/26.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class CellarerCell: UITableViewCell {
    @IBOutlet weak var labFirstLetter: UILabel!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labLiaison: UILabel!
    @IBOutlet weak var labMobile: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
