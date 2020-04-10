//
//  CellarerRepo.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/16.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

class CellarerRepo {
    static let cellarerRepo = CellarerRepo()
    
    let GET_CELLARERS_FAIL = "get cellarers fail"
    var cellarers: [Cellarer]?
    
    private init() {}
    
    func getCellarers(apiHandler: ApiHandler) {
        if let cellarers = self.cellarers {
            apiHandler.handler(cellarers)
        } else {
            getCellarersFromApi(apiHandler: apiHandler)
        }
    }

    
    
    
    // MARK: - call api
    
    private func getCellarersFromApi(apiHandler: ApiHandler) {
        AlamofireUtil.callApi(of: [Cellarer].self, url: Api.Url.GET_CELLARERS, redirect2Login: { () in apiHandler.redirect2Login() }) { data in
            if let cellarers = data.value {
                apiHandler.handler(cellarers)
//                self.cellarers = cellarers
//                self.tvCellarers.reloadData()
            } else {
                apiHandler.errorHandler(data.error?.errorDescription ?? "GET_CELLARERS_FAIL")
            }
        }
    }
}
