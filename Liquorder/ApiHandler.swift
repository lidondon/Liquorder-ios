//
//  ApiHandler.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/16.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

class ApiHandler {
    var handler: ((Any) -> Void)!
    var errorHandler: ((String) -> Void)!
    var redirect2Login: (() -> Void)!
}
