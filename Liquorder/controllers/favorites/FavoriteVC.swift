//
//  FavoriteVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/24.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var cvCategories: UICollectionView!
    @IBOutlet weak var tvItems: UITableView!
    
    let CELL = "cell"
    let CELLARER_FONT_SIZE = 17
    let apiGroup = DispatchGroup()
    var dicItems: [Int: [LiquorItem]] = [:]
    var selectedCategoryIndex = 0
    
    var favorites: [FavoriteItem]! {
        didSet {
            getCategories()
        }
    }
    
    var categories: [Category]? {
        didSet {
            DispatchQueue.main.async {
                self.cvCategories.reloadData()
                if self.categories != nil && self.categories!.count > 0 {
                    self.cvCategories.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
                }
            }
        }
    }
    
    var items: [LiquorItem]? {
        didSet {
            if items != nil {
                DispatchQueue.main.async {
                    self.tvItems.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
    }
    
    private func getItemsByCategoryId(id: Int) {
        if let items = dicItems[id] {
            self.items = items
        } else {
            getItemsByCategoryIdFromApi(id: id)
        }
    }
    
    private func bindFavorites(items: [LiquorItem]) -> [LiquorItem] {
        var result: [LiquorItem] = []
        
        items.forEach { item in
            var i = item
            
            if let index = favorites.firstIndex(where: { $0.liquorId == item.id }) {
                i.favoriteId = favorites[index].id
            }
            result.append(i)
        }
        
        return result
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL, for: indexPath) as! CategoryCell
        
        if let category = self.categories?[indexPath.row] {
            cell.setCategory(category: category)
            if cell.isSelected {
                selectedCategoryIndex = indexPath.row
                getItemsByCategoryId(id: category.id)
                cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE), weight: UIFont.Weight.bold)
            } else {
                cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE))
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
            selectedCategoryIndex = indexPath.row
            getItemsByCategoryId(id: categories![indexPath.row].id)
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE), weight: UIFont.Weight.bold)
        }
    }
     
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE))
        }
     }
     
     //MARK: - UITableViewDataSource
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvItems.dequeueReusableCell(withIdentifier: CELL, for: indexPath) as! FavoriteCell

        cell.setItem(item: items![indexPath.row])

        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            let categoryId = categories![selectedCategoryIndex].id
        
            if let _ = item.favoriteId {
                removeFavorite(categoryId: categoryId, index: indexPath.row, favoriteId: item.favoriteId!)
            } else {
                addFavorite(categoryId: categoryId, index: indexPath.row, liquorId: item.id)
            }
            
        }
        tvItems.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_TO_DETAIL {
//            let detailVC = segue.destination as! DetailVC
//            let index = tvOrders.indexPathForSelectedRow!.row
//
//            detailVC.order = orders![index]
//            detailVC.reloadOrders = { () in self.getOrders() }
//        }
//    }

    //MARK: - call api
    
    private func getFavorites() {
        let url = String(format: Api.Url.GET_FAVORITES)
        
        AlamofireUtil.callApi(of: [FavoriteItem].self, url: url, redirect2Login: redirect2Login) { data in
            if let favorites = data.value {
                self.favorites = favorites
            } else {
                Util.printError(message: String(describing: data.error?.failureReason))
            }
        }
    }
    
    func getCategories() {
        let url = String(format: Api.Url.GET_LIQUOR_CATEGORIES)
        
        AlamofireUtil.callApi(of: [Category].self, url: url, redirect2Login: redirect2Login) { data in
            if let categories = data.value {
                self.categories = categories
            } else {
                Util.printError(message: String(describing: data.error))
            }
        }
    }

    func getItemsByCategoryIdFromApi(id: Int) {
        let url = String(format: Api.Url.GET_LIQUOR_CATEGORY_ITEMS, id)
        
        AlamofireUtil.callApi(of: [LiquorItem].self, url: url, redirect2Login: redirect2Login) { data in
            if let items = data.value {
                self.items = self.bindFavorites(items: items)
                self.dicItems[id] = self.items
            } else {
                debugPrint(data.error ?? "")
                //Util.printError(message: String(describing: data.error?.failureReason))
            }
        }
    }
    
    private func addFavorite(categoryId: Int, index: Int, liquorId: Int) {
        let url = String(format: Api.Url.ADD_FAVORITE)
        
        AlamofireUtil.callApi(of: FavoriteItem.self,
          url: url,
          method: HTTPMethod.post,
          parameters: FavoriteRequest(liquorId: liquorId).toDictionary(),
          encoding: JSONEncoding.default,
          redirect2Login: redirect2Login) { data in
            if let item = data.value {
                self.dicItems[categoryId]![index].favoriteId = item.id
                self.items![index].favoriteId = item.id
            } else {
                debugPrint(data.error ?? "")
                //Util.printError(message: String(describing: data.error?.failureReason))
            }
        }
    }
    
    private func removeFavorite(categoryId: Int, index: Int, favoriteId: Int) {
        let url = String(format: Api.Url.REMOVE_FAVORITE)
        
        AlamofireUtil.callApi(url: url,
          method: HTTPMethod.post,
          parameters: FavoriteRequest(favoriteId: favoriteId).toDictionary(),
          encoding: JSONEncoding.default,
          redirect2Login: redirect2Login) { data in
            if let code = data.response?.statusCode, 200..<300 ~= code {
                self.dicItems[categoryId]![index].favoriteId = nil
                self.items![index].favoriteId = nil
            } else {
                debugPrint(data.error ?? "")
            }
        }
    }
}
