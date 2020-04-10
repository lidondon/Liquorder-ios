//
//  DicConvertable.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/21.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

protocol DicConvertable: Codable {
    
}

extension DicConvertable {
    func toDictionary() -> Dictionary<String, Any>? {
        var result: Dictionary<String, Any>? = nil

        do {
            let data = try JSONEncoder().encode(self)

            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            
        }

        return result
    }
}
