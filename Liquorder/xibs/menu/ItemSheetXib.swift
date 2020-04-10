//
//  ItemSheetVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/4.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class ItemSheetXib: UIView {
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labCapacity: UILabel!
    @IBOutlet weak var labBottling: UILabel!
    @IBOutlet weak var labQuantity: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCommit: UIButton!
    
    @IBAction func btnMinusOnClick(_ sender: Any) {
        if quantity > minQuantity {
            quantity -= 1
        }
    }
    
    @IBAction func btnAddOnClick(_ sender: Any) {
        quantity += 1
    }
    
    
    @IBAction func btnCommitOnClick(_ sender: Any) {
        if caller == .Menu {
            cartRepo.addItem(item: item.toMenuItem())
        } else {
            cartRepo.updateItem(item: item)
        }
        closeSheet()
    }
    
    
    let ITEM_SHEET_XIB = "ItemSheetXib"
    var minQuantity = 0
    var item: OrderItem!
    var cartRepo = CartRepo.cartRepo
    var closeSheet: (() -> Void)!
    var caller = MenuCaller.Menu
    
    var quantity: Int = 0 {
        didSet {
            quantity = (quantity < minQuantity) ? minQuantity : quantity
            if quantity == minQuantity {
                btnMinus.tintColor = UIColor.gray
            }
            item.quantity = quantity
            labQuantity.text = String(quantity)
            if quantity == minQuantity {
                btnMinus.tintColor = UIColor.gray
            } else {
                btnMinus.tintColor = UIColor(rgb: 0xFFB428)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ItemSheetXib", owner: self, options: nil)
        addSubview(vContent)
        vContent.frame = self.bounds
        vContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func clear() {
        item = nil
        minQuantity = 0
        labName.text = ""
        labCapacity.text = ""
        labBottling.text = ""
        labQuantity.text = ""
    }
    
    func setItem(item: OrderItem) {
        self.item = item
        labName.text = item.liquorName
        labCapacity.text = "\(String(item.liquorCapacity)) c.c."
        labBottling.text = String(item.liquorBottling)
        if caller == .Cart {
            minQuantity = 0
            quantity = item.quantity
            btnCommit.setTitle(Strings.UPDATE, for: .normal)
        } else {
            minQuantity = 1
            quantity = 1
        }
    }
}
