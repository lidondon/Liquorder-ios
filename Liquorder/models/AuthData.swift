//
//  AuthData.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/21.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

struct AuthData: DicConvertable {
    var token: String;
    var refreshToken: String;
}
