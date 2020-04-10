//
//  LoginRepo.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/21.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation
import Alamofire

class LoginRepo {
    static let loginRepo = LoginRepo()
    var authData: AuthData?
    
    private init() {}
}
