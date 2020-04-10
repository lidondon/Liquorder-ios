//
//  OrderCell.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/16.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var labFormNumber: UILabel!
    @IBOutlet weak var labMerchantName: UILabel!
    @IBOutlet weak var labCreateDate: UILabel!
    @IBOutlet weak var labStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setOrder(order: Order) {
        labFormNumber.text = order.formNumber
        labMerchantName.text = order.merchantName
        labCreateDate.text = order.createDateTime
        labStatus.text = order.orderStatus
        setStatus(status: order.orderStatus)
    }

    func setStatus(status: String) {
        switch status {
        case Status.SUBMIT:
            labStatus.backgroundColor = Config.colorSUBMIT
        case Status.ACCEPT:
            labStatus.backgroundColor = Config.colorACCEPT
        case Status.REJECT:
            labStatus.backgroundColor = Config.colorREJECT
        default:
            labStatus.backgroundColor = Config.colorSAVE
        }
    }
    
    
}
