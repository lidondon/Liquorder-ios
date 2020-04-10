//
//  Util.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/20.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Util {
    
    static func warn(presenter: UIViewController, title: String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        alert(presenter: presenter, title: title, message: message, cancelHandler: handler)
    }
    
    static func confirm(presenter: UIViewController, title: String, message: String? = nil, handler: @escaping (UIAlertAction) -> Void) {
        alert(presenter: presenter, title: title, message: message, handler: handler)
    }
    
    static func alert(presenter: UIViewController, title: String, message: String? = nil,
      handler: ((UIAlertAction) -> Void)? = nil,
      cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelActionText = (cancelHandler == nil) ? Strings.CANCEL : Strings.SURE
        let cancelAction = UIAlertAction(title: cancelActionText, style: .cancel, handler: cancelHandler)
        
        cancelAction.setValue(Config.colorPrimaryDark, forKey: "titleTextColor")
        if handler != nil {
            let commitAction = UIAlertAction(title: Strings.SURE, style: .default, handler: handler)
            
            commitAction.setValue(Config.colorPrimaryDark, forKey: "titleTextColor")
            alert.addAction(commitAction)
        }
        alert.addAction(cancelAction)
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
    static func printError(message: String) {
        print("\(#file)->、\(#function) error: message")
    }
    
    static func login(loginParams: LoginParams, errorHandler: @escaping () -> Void, handler: @escaping () -> Void) {
        AF.request(Api.Url.LOGIN_URL, method: .post, parameters: loginParams.toDictionary(), encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: AuthData.self) { data in
                if let authData = data.value {
                    LoginRepo.loginRepo.authData = authData
                    handler()
                } else {
                    errorHandler()
                }
        }
    }
}
