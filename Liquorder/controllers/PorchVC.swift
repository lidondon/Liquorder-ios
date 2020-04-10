//
//  PorchVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/19.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import CoreData

class PorchVC: UIViewController {
    let SEGUE_TO_LOGIN = "segue2Login"
    let SEGUE_TO_MAIN = "segue2Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        if let loginData = getLoginData() {
            let loginParams = LoginParams(email: loginData.email!, password: loginData.pwd!)
            
            Util.login(loginParams: loginParams, errorHandler: { self.performSegue(withIdentifier: self.SEGUE_TO_LOGIN, sender: self) }) {
                self.performSegue(withIdentifier: self.SEGUE_TO_MAIN, sender: self)
            }
        } else {
            performSegue(withIdentifier: SEGUE_TO_LOGIN, sender: self)
        }
    }

    private func getLoginData() -> LoginDataMO? {
        var result: LoginDataMO? = nil

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<LoginDataMO> = LoginDataMO.fetchRequest()
            //let request = NSFetchRequest<LoginDataMO>(entityName: "LoginData")

            do {
                let datas = try context.fetch(request)

                if datas.count > 0 {
                    result = datas[0]
                }
            } catch {
                debugPrint(error)
            }
        }

        return result
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
