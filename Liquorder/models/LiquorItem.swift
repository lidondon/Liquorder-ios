//
//  LiquorItem.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/24.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct LiquorItem: Codable {
    var id: Int = 0
    var brandId: Int
    var bottling: String
    var capacity: Int
    var name: String
    var nameEn: String
    var favoriteId: Int?
}
