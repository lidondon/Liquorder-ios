//
//  OrderItem.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/7.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct OrderItem: DicConvertable {
    var id: Int = 0
    var liquorId: Int
    var unitId: Int?
    var liquorBottling: String
    var liquorCapacity: Int
    var liquorName: String
    var liquorNameEn: String
    var price: Int = 0
    var quantity: Int = 0
    // order item
    var orderId: Int = 0
    var menuitemDesc: String?
    var categoryId: Int?
    var categoryName: String?
    
    func toMenuItem() -> MenuItem {
        return MenuItem(liquorId: liquorId,
                         liquorBottling: liquorBottling,
                         liquorCapacity: liquorCapacity,
                         liquorName: liquorName,
                         liquorNameEn: liquorNameEn,
                         price: price,
                         quantity: quantity,
                         itemDesc: menuitemDesc);
    }
}
