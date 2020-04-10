//
//  CreateOrderVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/24.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import Alamofire

class CreateOrderVC: BaseVC,  UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tvCellarers: UITableView!
    
    let CELL = "cell"
    let SEGUE_TO_MENU = "segue2Menu"
    let cartRepo = CartRepo.cartRepo
    var cellarers: [Cellarer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCellarers()
    }
    
    func getCellarers() {
        let apiHandler = getBasicApiHandler()
        
        apiHandler.handler = { data in
            if let cellarers = data as? [Cellarer] {
                self.cellarers = cellarers
                self.tvCellarers.reloadData()
            }
        }
        CellarerRepo.cellarerRepo.getCellarers(apiHandler: apiHandler)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellarers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL) as! CellarerCell
        
        if let cellarers = self.cellarers {
            let cellarer = cellarers[indexPath.row]
            
            cell.labName.text = cellarer.name
            cell.labLiaison.text = cellarer.liaison
            cell.labMobile.text = cellarer.mobile
            cell.labFirstLetter.text = String(cellarer.name.first!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_MENU {
            if let indexPath = tvCellarers.indexPathForSelectedRow {
                let destination = segue.destination as! MenuVC
                
                destination.cellarer = cellarers![indexPath.row]
            }
        }
    }
}
