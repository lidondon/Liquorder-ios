//
//  BaseItem.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/1.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    var id: Int = 0
    var liquorId: Int
    var unitId: Int?
    var liquorBottling: String
    var liquorCapacity: Int
    var liquorName: String
    var liquorNameEn: String
    var price: Int = 0
    var quantity: Int?
    //menu item
    var isConsumerFav: Bool?
    var itemDesc: String?
    
    func toOrderItem() -> OrderItem {
        return OrderItem(liquorId: liquorId,
                         liquorBottling: liquorBottling,
                         liquorCapacity: liquorCapacity,
                         liquorName: liquorName,
                         liquorNameEn: liquorNameEn,
                         price: price,
                         quantity: quantity ?? 0,
                         menuitemDesc: itemDesc);
    }
}
