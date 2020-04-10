//
//  SaveOrderItemRequest.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/13.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct SaveOrderItemRequest: DicConvertable {
    var itemsToUpdate: [OrderItem]?
    var itemIdsToDelete: [Int]?
}
