//
//  CartXib.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/10.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import Alamofire

class CartXib: UIView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var sOperation: UIStackView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labTotalAmount: UILabel!
    @IBOutlet weak var tvItems: UITableView!
    @IBOutlet weak var sWholeSheet: UIStackView!
    @IBOutlet weak var vMask: UIView!
    @IBOutlet weak var vItemSheet: ItemSheetXib!
    
    @IBAction func maskOnTap(_ sender: Any) {
        sWholeSheet.isHidden = true
        showOrHideBtnMenu(isHidden: isNotEditable())
    }
    
    @IBAction func btnSaveOnClick(_ sender: Any) {
        processOrder(isSubmit: false)
    }
    
    @IBAction func onSubmitOnClick(_ sender: Any) {
        processOrder(isSubmit: true)
    }
    
    let CART_XIB = "CartXib"
    let CART_ITEM_CELL = "CartItemCell"
    let cartRepo = CartRepo.cartRepo
    var cellarerId: Int?
    var order: Order?
    var items: [OrderItem]!
    var redirect2Login: (() -> Void)!
    var isHideBtnMenu: ((Bool) -> Void)!
    var errorHandler: ((String?) -> Void)!
    var processSuccess: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        tvItems.register(UINib.init(nibName: CART_ITEM_CELL, bundle: nil), forCellReuseIdentifier: CART_ITEM_CELL)
        vItemSheet.caller = .Cart
        vItemSheet.closeSheet = { () in
            self.sWholeSheet.isHidden = true
            self.reloadData()
            self.showOrHideBtnMenu(isHidden: self.isNotEditable())
        }
        refresh()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(CART_XIB, owner: self, options: nil)
        addSubview(vContent)
        vContent.frame = self.bounds
        vContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func refresh() {
        let isHidden = isNotEditable()
        
        reloadData()
        showOrHideBtnMenu(isHidden: isHidden)
        sOperation.isHidden = isHidden
    }
    
    func reloadData() {
        var totalAmount = 0
        
        items = cartRepo.getAllItems()
        items.forEach({ item in totalAmount += item.quantity * item.price })
        labTotalAmount.text = "$ \(totalAmount)"
        tvItems.reloadData()
    }
    
    private func isNotEditable() -> Bool {
        return order != nil && order!.orderStatus != "SAVE"
    }
    
    private func showOrHideBtnMenu(isHidden: Bool) {
        if let isHideBtnMenu = self.isHideBtnMenu {
            isHideBtnMenu(isHidden)
        }
    }
    
    private func processOrder(isSubmit: Bool) {
        if order == nil && cellarerId == nil {
            print("\(#file)->、\(#function) error: no orderId or cellarerId")
        } else if let orderId = self.order?.id {
            updateOrder(id: orderId, isSubmit: isSubmit)
        } else {
            createOrder(isSubmit: isSubmit)
        }
    }

    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvItems.dequeueReusableCell(withIdentifier: CART_ITEM_CELL, for: indexPath) as! CartItemCell
        
        cell.setItem(item: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tvItems.deselectRow(at: indexPath, animated: false)
        if !isNotEditable() {
            sWholeSheet.isHidden = false
            vItemSheet.setItem(item: items![indexPath.row])
            showOrHideBtnMenu(isHidden: true)
        }
    }
    
    
    //MARK: - call api
    
    private func createOrder(isSubmit: Bool) {
        let url = String(format: Api.Url.CREATE_ORDER, String(isSubmit))
        let parameters = cartRepo.getCreateOrderRequest(cellarerId: cellarerId!).toDictionary()
        
        processOrder(url: url, parameters: parameters!, isSubmit: isSubmit)
    }
    
    private func updateOrder(id: Int, isSubmit: Bool) {
        let url = String(format: Api.Url.UPDATE_ORDER, id, String(isSubmit))
        let parameters = cartRepo.getSaveOrderItemRequest().toDictionary()
        
        processOrder(url: url, parameters: parameters!, isSubmit: isSubmit)
    }
    
    private func processOrder(url: String, parameters: Parameters, isSubmit: Bool) {
        AlamofireUtil.callApi(url: url,
          method: HTTPMethod.post,
          parameters: parameters,
          encoding: JSONEncoding.default,
          redirect2Login: redirect2Login!) { data in
            if let code = data.response?.statusCode, 200..<300 ~= code {
                self.processSuccess()
            } else {
                self.errorHandler(data.error?.errorDescription)
            }
        }
    }
}
