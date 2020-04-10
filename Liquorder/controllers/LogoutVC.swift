//
//  LogoutVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/30.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import CoreData

class LogoutVC: UIViewController {
    let SEGUE_TO_LOGIN = "segue2Loigin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<LoginDataMO> = LoginDataMO.fetchRequest()
            //let request = NSFetchRequest<LoginDataMO>(entityName: "LoginData")

            do {
                let datas = try context.fetch(request)

                if datas.count > 0 {
                    context.delete(datas[0])
                    try context.save()
                }
                performSegue(withIdentifier: SEGUE_TO_LOGIN, sender: self)
            } catch {
                debugPrint(error)
            }
        }
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
