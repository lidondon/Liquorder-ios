//
//  MenuPlusVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/20.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class MenuPlusVC: BaseVC {
    @IBOutlet weak var vMenuXib: MenuXib!
    
    @IBAction func navBackOnClick(_ sender: Any) {
        parentReloadData()
        navigationController?.popViewController(animated: true)
    }

    let cartRepo = CartRepo.cartRepo
    var cellarerId: Int!
    var parentReloadData: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        vMenuXib.isShowQantity = true
        vMenuXib.redirect2Login = { () in self.redirect2Login() }
        vMenuXib.cellarerId = cellarerId
        vMenuXib.isShowQantity = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vMenuXib.refreshView()
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
