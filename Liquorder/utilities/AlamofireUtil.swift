//
//  AlamofireUtil.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/26.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

final class AlamofireUtil {
    static let BEARER_PREFIX = "Bearer "
    static var hasRecalled = false
    
    static func callApi(url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        interceptor: RequestInterceptor? = nil,
        redirect2Login: @escaping () -> Void,
        completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let headers: HTTPHeaders = [.authorization(BEARER_PREFIX + (LoginRepo.loginRepo.authData?.token ?? ""))]

        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseJSON{ data in
                if (data.error?.responseCode == 401 && !hasRecalled) {
                    hasRecalled = true
                    refreshTokenAndCallApiAgain(redirect2Login: redirect2Login) {
                        callApi(url: url, method: method, parameters: parameters, encoding: encoding,
                                interceptor: interceptor, redirect2Login: redirect2Login, completionHandler: completionHandler)
                    }
                } else {
                    completionHandler(data)
                }
        }
    }
    
    static func callApi<T: Decodable>(of type: T.Type = T.self,
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        interceptor: RequestInterceptor? = nil,
        redirect2Login: @escaping () -> Void,
        completionHandler: @escaping (AFDataResponse<T>) -> Void) {
        let headers: HTTPHeaders = [.authorization(BEARER_PREFIX + (LoginRepo.loginRepo.authData?.token ?? ""))]

        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: T.self) { data in
                if (data.error?.responseCode == 401 && !hasRecalled) {
                    hasRecalled = true
                    refreshTokenAndCallApiAgain(redirect2Login: redirect2Login) {
                        callApi(of: T.self, url: url, method: method, parameters: parameters, encoding: encoding,
                                interceptor: interceptor, redirect2Login: redirect2Login, completionHandler: completionHandler)
                    }
                } else {
                    completionHandler(data)
                }
        }
    }
    
    static func refreshTokenAndCallApiAgain(redirect2Login: @escaping () -> Void, task: @escaping () -> Void) {
        hasRecalled = false
        AF.request(Api.Url.REFRESH_TOKEN_URL, method: .post, parameters: LoginRepo.loginRepo.authData!.toDictionary(), encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: AuthData.self) { data in
                if let authData = data.value {
                    LoginRepo.loginRepo.authData = authData
                    task()
                } else {
                    redirect2Login()
                }
        }
    }
}
