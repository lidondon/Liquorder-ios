//
//  MenuVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/27.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class MenuVC: BaseVC {
    @IBOutlet weak var vMenuXib: MenuXib!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBAction func navBackOnClick(_ sender: Any) {
        if !cartRepo.isEmpty() {
            Util.confirm(presenter: self, title: Strings.CART_IS_NOT_EMPTY) { _ in
                self.cartRepo.clear()
                self.navigationController?.popViewController(animated: true)
           }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnCartOnClick(_ sender: Any) {
        performSegue(withIdentifier: SEGUE_TO_CART, sender: self)
    }
    
    let SEGUE_TO_CART = "segue2Cart"
    let cartRepo = CartRepo.cartRepo
    var cellarer: Cellarer!

    override func viewDidLoad() {
        super.viewDidLoad()
        vMenuXib.isShowQantity = true
        vMenuXib.redirect2Login = { () in self.redirect2Login() }
        vMenuXib.cellarerId = cellarer.id
        vMenuXib.isHideBtnCart = { isHidden in self.btnCart.isHidden = isHidden }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vMenuXib.refreshView()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_CART {
            if let cartVC = segue.destination as? CartVC {
                cartVC.cellarer = cellarer
                cartVC.closeMenuVC = { () in self.navigationController?.popViewController(animated: false) }
            }
        }
    }

    
}
