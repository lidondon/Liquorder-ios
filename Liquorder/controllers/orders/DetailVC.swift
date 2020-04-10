//
//  DetailVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/19.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class DetailVC: BaseVC {

    @IBOutlet weak var vCartXib: CartXib!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBAction func navBackOnClick(_ sender: Any) {
        if !cartRepo.isEmpty() {
            Util.confirm(presenter: self, title: Strings.CART_IS_NOT_EMPTY) { _ in
                self.cartRepo.clear()
                self.navigationController?.popViewController(animated: true)
           }
        } else {
            cartRepo.clear()
            navigationController?.popViewController(animated: true)
        }
    }
    
    let SEGUE_TO_MENU = "segue2Menu"
    let cartRepo = CartRepo.cartRepo
    var order: Order!
    var closeMenuVC: (() -> Void)?
    var reloadOrders: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderItems()
        setTitle()
        initVCartXib()
    }
    
    private func setTitle() {
        if let formNumber = order.formNumber {
            navigation.title = formNumber
        } else {
            navigation.title = order.merchantName
        }
    }
    
    private func initVCartXib() {
        vCartXib.order = order
        vCartXib.redirect2Login = { () in self.redirect2Login() }
        vCartXib.isHideBtnMenu = { isHidden in
            self.btnMenu.isHidden = isHidden
            
        }
        vCartXib.errorHandler = { error in Util.warn(presenter: self, title: String(format: Strings.CART_PROCESS_ERROR, error ?? "")) }
        vCartXib.processSuccess = { () in
            CartRepo.cartRepo.clear()
            Util.warn(presenter: self, title: Strings.CART_PROCESS_SUCCESS) { action in
                self.navigationController?.popViewController(animated: true)
                if let reloadOrders = self.reloadOrders {
                    reloadOrders()
                }
            }
        }
        vCartXib.refresh()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_MENU {
            let menu = segue.destination as! MenuPlusVC
            
            menu.cellarerId = order.merchantId
            menu.parentReloadData = { () in self.vCartXib.refresh() }
        }
    }

    //MARK: - call api
    
    private func getOrderItems() {
        let url = String(format: Api.Url.GET_ORDER_ITEMS, order.id)
        
        AlamofireUtil.callApi(of: [OrderItem].self, url: url, redirect2Login: redirect2Login) { data in
            if let items = data.value {
                self.cartRepo.setOrdersItems(items: items)
                self.vCartXib.refresh()
            } else {
                debugPrint(data.error ?? "")
            }
        }
    }
}
