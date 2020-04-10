//
//  CartRepo.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/6.
//  Copyright © 2020 creationspace. All rights reserved.
//

import Foundation

class CartRepo {
    static let cartRepo = CartRepo()
    
    private(set) var menuItems: [MenuItem] = []
    private(set) var orderItems: [OrderItem] = []
    private(set) var snapshot: [OrderItem]?
    
    private init() {}
    
    func isEmpty() -> Bool {
        let result = menuItems.count == 0
        
        return (result && !isOrderItemsChanged())
    }
    
    func clear() {
        menuItems.removeAll()
        orderItems.removeAll()
        snapshot?.removeAll()
        snapshot = nil
        print("cart clear")
    }
    
    func getAllItems() -> [OrderItem] {
        var result: [OrderItem] = []
        
        menuItems.forEach { item in result.append(item.toOrderItem()) }
        orderItems.forEach { item in result.append(item) }
        
        return result
    }
    
    func setOrdersItems(items: [OrderItem]) {
        self.orderItems = items
        snapshot = items
    }
    
    func isOrderItemsChanged() -> Bool {
        var result = false
        
        if snapshot != nil {
            if snapshot!.count == orderItems.count {
                for sItem in snapshot! {
                    if let index = orderItems.firstIndex(where: { $0.liquorId == sItem.liquorId }) {
                        if sItem.quantity != orderItems[index].quantity {
                            result = true
                            break
                        }
                    } else {
                        result = true
                        break
                    }
                }
            } else {
                result = true
            }
        }
        
        return result
    }
    
    func addItem(item: MenuItem) {
        if let index = orderItems.firstIndex(where: { $0.liquorId == item.liquorId }) {
            orderItems[index].quantity += item.quantity!
        } else {
            if let index = menuItems.firstIndex(where: { $0.liquorId == item.liquorId }) {
                menuItems[index].quantity! += item.quantity!
            } else {
                menuItems.append(item)
            }
        }
    }
    
    func updateItem(item: OrderItem) {
        if let index = orderItems.firstIndex(where: { $0.liquorId == item.liquorId }) {
            if item.quantity == 0 {
                orderItems.remove(at: index)
            } else {
                orderItems[index].quantity = item.quantity
            }
        } else if let index = menuItems.firstIndex(where: { $0.liquorId == item.liquorId }) {
            if item.quantity == 0 {
                menuItems.remove(at: index)
            } else {
                menuItems[index].quantity = item.quantity
            }
        }
    }
    
    func getCreateOrderRequest(cellarerId: Int) -> CreateOrderRequest {
        var result = CreateOrderRequest(merchantId: cellarerId, orderitemRequest: SaveOrderItemRequest())
        
        result.orderitemRequest.itemsToUpdate = []
        menuItems.forEach({ item in
            result.orderitemRequest.itemsToUpdate!.append(item.toOrderItem())
        })
        
        return result
    }
    
    func getSaveOrderItemRequest() -> SaveOrderItemRequest {
        var result = SaveOrderItemRequest()
        var items2Update = [OrderItem]()
        var itemIdsToDelete = [Int]()
        
        menuItems.forEach({ item in items2Update.append(item.toOrderItem()) })
        if let snapshot = self.snapshot {
            snapshot.forEach({ sItem in
                if let index = orderItems.firstIndex(where: { $0.liquorId == sItem.liquorId }) {
                    let item = orderItems[index]
                    
                    if sItem.quantity != item.quantity {
                        items2Update.append(item)
                    }
                } else {
                    itemIdsToDelete.append(sItem.id)
                }
            })
        }
        result.itemsToUpdate = items2Update
        if itemIdsToDelete.count > 0 {
            result.itemIdsToDelete = itemIdsToDelete
        }
        
        return result
    }
}
