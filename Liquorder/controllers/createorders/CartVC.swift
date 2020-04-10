//
//  CartVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/10.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class CartVC: BaseVC {
    @IBOutlet weak var vCartXib: CartXib!
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBAction func navBackOnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var cellarer: Cellarer!
    var closeMenuVC: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = cellarer.name
        vCartXib.cellarerId = cellarer.id
        vCartXib.redirect2Login = { () in self.redirect2Login() }
        vCartXib.errorHandler = { error in Util.warn(presenter: self, title: String(format: Strings.CART_PROCESS_ERROR, error ?? "")) }
        vCartXib.processSuccess = { () in
            CartRepo.cartRepo.clear()
            if let closeMenuVC = self.closeMenuVC {
                Util.warn(presenter: self, title: Strings.CART_PROCESS_SUCCESS) { action in
                    self.navigationController?.popViewController(animated: true)
                    closeMenuVC()
                }
            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_CLOSE_MENU {
//            if let menuVC = segue.destination as? MenuVC {
//                menuVC.dismiss(animated: false, completion: nil)
//            }
//        }
//    }

}
