//
//  MenuVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/2/28.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import Alamofire

class MenuXib: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var cvCategories: UICollectionView!
    @IBOutlet weak var tvItems: UITableView!
    @IBOutlet weak var sWholeSheet: UIStackView!
    @IBOutlet weak var vMask: UIView!
    @IBOutlet weak var vItemSheet: ItemSheetXib!
    
    @IBAction func maskOnTap(_ sender: Any) {
        sWholeSheet.isHidden = true
        self.showOrHideBtnCart()
    }
    
    
    let CATEGORY_CELL = "CategoryCell"
    let MENU_ITEM_CELL = "MenuItemCell"
    let MENU_XIB = "MenuXib"
    let ITEM_SHEET_XIB = "ItemSheetXib"
    var isShowQantity = false
    let CATEGORY_FONT_SIZE = 17
    let cartRepo = CartRepo.cartRepo
    var dicItems: [Int: [MenuItem]] = [:]
    var redirect2Login: (() -> Void)!
    var isHideBtnCart: ((Bool) -> Void)?
    
    var cellarerId: Int! {
        didSet {
            getMenu()
        }
    }
    
    var menu: CellarerMenu! {
        didSet {
            getCategories()
        }
    }
    
    var categories: [Category]! {
        didSet {
            DispatchQueue.main.async {
                self.cvCategories.reloadData()
                if self.categories != nil && self.categories!.count > 0 {
                    self.cvCategories.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
                }
            }
        }
    }
    
    var items: [MenuItem]? {
        didSet {
            if items != nil {
                DispatchQueue.main.async {
                    self.tvItems.reloadData()
                }
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
        cvCategories.register(UINib.init(nibName: CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: CATEGORY_CELL)
        tvItems.register(UINib.init(nibName: MENU_ITEM_CELL, bundle: nil), forCellReuseIdentifier: MENU_ITEM_CELL)
        vItemSheet.closeSheet = { () in
            self.sWholeSheet.isHidden = true
            self.refreshView()
        }
    }
    
    func refreshView() {
        self.tvItems.reloadData()
        self.showOrHideBtnCart()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(MENU_XIB, owner: self, options: nil)
        addSubview(vContent)
        vContent.frame = self.bounds
        vContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func getItemsByCategoryId(id: Int) {
        if let items = dicItems[id] {
            self.items = items
        } else {
            getItemsByCategoryIdFromApi(id: id)
        }
    }
    
    private func showOrHideBtnCart(isHidden: Bool? = nil) {
        if let isHideBtnCart = self.isHideBtnCart {
            isHideBtnCart(isHidden ?? cartRepo.isEmpty())
        }
    }


    // MARK: - UICollectionViewDataSource

    //   func numberOfSections(in collectionView: UICollectionView) -> Int {
    //       // #warning Incomplete implementation, return the number of sections
    //       return 0
    //   }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CATEGORY_CELL, for: indexPath) as! CategoryCell

        if let categories = self.categories {
            let category = categories[indexPath.row]
            
            cell.setCategory(category: category)
            if cell.isSelected {
                getItemsByCategoryId(id: category.id)
                cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CATEGORY_FONT_SIZE), weight: UIFont.Weight.bold)
            } else {
                cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CATEGORY_FONT_SIZE))
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            getItemsByCategoryId(id: categories[indexPath.row].id)
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CATEGORY_FONT_SIZE), weight: UIFont.Weight.bold)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CATEGORY_FONT_SIZE))
        }
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
       return false
    }

   func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
       return false
   }

   func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvItems.dequeueReusableCell(withIdentifier: MENU_ITEM_CELL, for: indexPath) as! MenuItemCell
        var item = items![indexPath.row]
        
        if isShowQantity, let cartIndex = cartRepo.menuItems.firstIndex(where: { $0.liquorId == item.liquorId }) {
            let cartItem = cartRepo.menuItems[cartIndex]
            
            item.quantity = cartItem.quantity
        }
        cell.setMenuItem(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell =  tvItems.cellForRow(at: indexPath) as! MenuItemCell
        
        tvItems.deselectRow(at: indexPath, animated: false)
        sWholeSheet.isHidden = false
        vItemSheet.setItem(item: items![indexPath.row].toOrderItem())
        showOrHideBtnCart(isHidden: true)
    }
    
    // MARK: - call api
    
    func getMenu() {
        let url = String(format: Api.Url.GET_CELLARER_ACTIVE_MENU, cellarerId)
        
        AlamofireUtil.callApi(of: CellarerMenu.self, url: url, redirect2Login: redirect2Login) { data in
            if let menu = data.value {
                self.menu = menu
            } else {
                Util.printError(message: String(describing: data.error))
            }
        }
    }
    
    func getCategories() {
        let url = String(format: Api.Url.GET_MENU_CATEGORIES, self.menu.id)
        
        AlamofireUtil.callApi(of: [Category].self, url: url, redirect2Login: redirect2Login) { data in
            if let categories = data.value {
                self.categories = categories
            } else {
                Util.printError(message: String(describing: data.error))
            }
        }
    }
    
    func getItemsByCategoryIdFromApi(id: Int) {
        let url = String(format: Api.Url.GET_MENU_CATEGORY_ITEMS, self.menu.id, id)
        
        AlamofireUtil.callApi(of: [MenuItem].self, url: url, redirect2Login: redirect2Login) { data in
            if let items = data.value {
                self.items = items
                self.dicItems[id] = items
            } else {
                debugPrint(data.error ?? "")
                //Util.printError(message: String(describing: data.error?.failureReason))
            }
        }
    }
}

