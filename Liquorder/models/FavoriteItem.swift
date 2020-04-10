//
//  FavoriteItem.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/25.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct FavoriteItem: Codable {
    var id: Int
    var liquorId: Int
    var bottling: String?
    var capacity: Int
    var name: String?
    var nameEn: String?
}
