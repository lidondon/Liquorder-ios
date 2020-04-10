//
//  BaseVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/2.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    let LOGIN = "login"
    let MAIN = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getBasicApiHandler() -> ApiHandler {
        let result = ApiHandler()
        
        result.handler = { any in }
        result.errorHandler = { error in self.errorHandler(error: error) }
        result.redirect2Login = { () in self.redirect2Login() }
        
        return result
    }
    
    func handler(data: Any) {
        
    }
    
    func errorHandler(error: String) {
        print("\(#file)->、\(#function) error: \(error)")
        Util.warn(presenter: self, title: String.init(format: Strings.CALL_API_ERROR, error))
    }
    
    func redirect2Login() {
        let storyBoard: UIStoryboard = UIStoryboard(name: MAIN, bundle: nil)
        let LoginVC = storyBoard.instantiateViewController(withIdentifier: LOGIN) as! LoginVC
        
        present(LoginVC, animated: true, completion: nil)
        dismiss(animated: false, completion: nil)
    }

}
