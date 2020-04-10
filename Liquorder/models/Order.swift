//
//  Order.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/16.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct Order: DicConvertable {
    var id: Int
    var merchantId: Int
    var merchantName: String
    var merchantSN: String
    var formNumber: String?
    var rejectReason: String?
    var orderStatus: String
    var createDateTime: String
    
    enum Status: String {
        case SAVE = "SAVE"
        case SUBMIT = "SUBMIT"
        case ACCEPT = "ACCEPT"
        case REJECT = "REJECT"
    }
}
