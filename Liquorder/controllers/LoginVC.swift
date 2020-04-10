//
//  LoginVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/20.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    @IBOutlet weak var tfEmail: DesignableUITextField!
    @IBOutlet weak var tfPassword: DesignableUITextField!
    
    let SEGUE_TO_MAIN = "segue2Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func checkInput() -> Bool {
        return !(tfEmail.text!.isEmpty || tfPassword.text!.isEmpty)
    }

    // MARK: - Actions
       
   @IBAction func login(_ sender: Any) {
        if checkInput() {
            login(loginParams: LoginParams(email: tfEmail.text!, password: tfPassword.text!))
        } else {
            Util.warn(presenter: self, title: Strings.COMPLETE_EMAIL_PASSWORD)
        }
   }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - call api
    
    func login(loginParams: LoginParams) {
        Util.login(loginParams: loginParams, errorHandler: { Util.warn(presenter: self, title: Strings.LOGIN_FAIL) }) {
            self.performSegue(withIdentifier: self.SEGUE_TO_MAIN, sender: self)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                let loginDataMO = LoginDataMO(context: context)
                
                loginDataMO.email = loginParams.email
                loginDataMO.pwd = loginParams.password
                try? context.save()
            }
        }
//        AF.request(Api.Url.LOGIN_URL, method: .post, parameters: loginParams.toDictionary(), encoding: JSONEncoding.default)
//            .validate(statusCode: 200 ..< 300)
//            .responseDecodable(of: AuthData.self) { data in
//                if let authData = data.value {
//                    LoginRepo.loginRepo.authData = authData
//                    self.performSegue(withIdentifier: self.SEGUE_TO_MAIN, sender: self)
//                } else {
//                    Util.warn(presenter: self, title: Strings.LOGIN_FAIL)
//                }
//        }
    }

}
