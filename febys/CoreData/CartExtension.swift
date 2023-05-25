//
//  CartExtension.swift
//  febys
//
//  Created by Waseem Nasir on 12/08/2021.
//

import Foundation
import CoreData

extension CartEntity{
    
    // --- UPDATE CART WITH API RESPONSE
    class func updateCart(withResponse items: [VendorProducts], completion: (() -> ())? = nil) {
        
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        
        for item in items {
            for product in item.products ?? [] {
                let variant = product.product?.variants?.first
                let skuId = variant?.skuId ?? ""
                fetchRequest.predicate = NSPredicate(format: "skuId == %@", skuId)

                do {
                    let result = try context.fetch(fetchRequest)
                    if let cart = result.first {
                        cart.quantity = Int64(product.qty ?? 0)
                    }else{
                        let cart = CartEntity(context: context)
                        cart.dateAdded = Date()
                        cart.imageURL = variant?.images?.first ?? ""
                        cart.name = product.product?.name ?? ""
                        cart.price = variant?.price?.value ?? 0.0
                        cart.currency = variant?.price?.currency ?? "GHS"
                        cart.productId = product.product?.id ?? ""
                        cart.quantity = Int64(product.qty ?? 0)
                        cart.skuId = variant?.skuId ?? ""
                        cart.storeName = item.vendor?.shopName
                        cart.storeImage = item.vendor?.businessInfo?.logo
                        cart.vendorId = item.vendor?.id ?? ""
                        cart.vendorRole = item.vendor?.role?.name ?? ""
                        cart.variantId = variant?.id ?? ""
                    }
                } catch {
                    print("Could not fetch cart")
                }
            }
        }
        
        DatabaseManager.saveContext()
        CartEntity.setCartStatus(isUpdated: false)
        completion?()
    }
    
    // --- UPDATE CART FROM PRODUCT DETAIL PAGE
    class func updateCart(withProduct variant: Variant, product: Product?, vendorId: String?){
        
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        let skuId = variant.skuId ?? ""
        fetchRequest.predicate = NSPredicate(format: "skuId == %@", skuId)
        do {
            let result = try context.fetch(fetchRequest)
            if let cart = result.first{
                cart.quantity += 1
            }else{
                let cart = CartEntity(context: context)
                cart.dateAdded = Date()
                cart.imageURL = variant.images?.first ?? ""
                cart.name = product?.name ?? ""
                cart.price = variant.price?.value ?? 0.0
                cart.currency = variant.price?.currency ?? "GHS"
                cart.productId = product?.id ?? ""
                cart.quantity = 1
                cart.skuId = variant.skuId ?? ""
                cart.storeName = product?.vendor?.shopName
                cart.storeImage = product?.vendor?.businessInfo?.logo
                cart.vendorId = vendorId ?? ""
                cart.vendorRole = product?.vendor?.role?.name ?? ""
                cart.variantId = variant.id ?? ""
            }
            DatabaseManager.saveContext()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                CartEntity.setupCartSync()
            }
            
            CartEntity.setCartStatus(isUpdated: true)
            
        } catch {
            print("Could not fetch cart")
        }
    }
    
    
    // --- UPDATE CART FROM CART DETAIL PAGE
    class func updateCart(product skuId: String, forQuantity quantity: Int ){
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "skuId == %@", skuId)
        do {
            let result = try context.fetch(fetchRequest)
            if let cart = result.first{
                if quantity == 0 {
                    context.delete(cart)
                }else{
                    cart.quantity = Int64(quantity)
                }
            }
            
            DatabaseManager.saveContext()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                CartEntity.setupCartSync()
            }
//            CartEntity.setCartStatus(isUpdated: true)
        } catch {
            print("Could not fetch cart")
        }
    }
    
    class func setCartStatus(isUpdated value: Bool) {
        UserDefaults.standard.set(value, forKey: Constants.updateCart)
    }
    
    class func getCartStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.updateCart)
    }
    
    static func clearAllFromCoreData(syncCart: Bool = false) {
        let context = DatabaseManager.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            print("data cleared")
            DatabaseManager.saveContext()
            if syncCart {
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
                setupCartSync()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func getAllCartItems() -> Int {
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.reduce(0) { (value, item)  in
                value + item.quantity
            }
            return Int(count)
        } catch {
            print("Could not fetch all cart items")
        }
        return 0
    }
    
    class func getAllCartItemsWithoutQuantity() -> Int {
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.reduce(0) { (value, item)  in
                (item.quantity > 1) ? value + 1 : value + item.quantity
            }
            
            return Int(count)
        } catch {
            print("Could not fetch all cart items")
        }
        return 0
    }
    
    class func cartItemsCurrency() -> String{
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result.first?.currency ?? "GHS"
        } catch {
            print("Could not fetch all cart items")
        }
        return "$"
    }
    
    class func cartItemsTotal() -> Double{
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.reduce(0) { (value, item)  in
                value + item.price * Double(item.quantity)
            }
            return count
        } catch {
            print("Could not fetch all cart items")
        }
        return 0
    }
    
    class func cartItemsSubTotal() -> Double{
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            let count = result.reduce(0) { (value, item)  in
                value + item.price * Double(item.quantity)
            }
            return count
        } catch {
            print("Could not fetch all cart items")
        }
        return 0
    }
    
    // --- WHEN APP LAUNCHES CHECK IF WE HAVE TO SYNC CART TO BACKEND
    class func setupCartSync(){
        // --- Make sure user is logged in before processing cart data
        guard let token = User.fetch()?.access_token, token != "" else { print("Returning from cart sync. No user found"); return }
        
        let context = DatabaseManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            var dictionaryArray = [[String:Any]]()
            
            _ = result.compactMap { item in
                let newItem = ["qty": item.quantity,
                               "sku_id": item.skuId!] as [String : Any]
                dictionaryArray.append(newItem)
            }
            
            CartEntity.syncCart(objects: dictionaryArray)
            
        } catch {
            print("Could not fetch all cart items")
        }
    }
    
    class func fetchAndUpdateCart(){
        // --- Make sure user is logged in before processing cart data
        guard let token = User.fetch()?.access_token, token != "" else { print("Returning from cart fetching. No user found"); return }
        
        CartEntity.fetchCart(){ cart in
            if !CartEntity.getCartStatus() { CartEntity.clearAllFromCoreData() }
            CartEntity.updateCart(withResponse: cart.cart?.vendorProducts ?? []){
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
                CartEntity.setupCartSync()
            }
        }
    }
}

//MARK: API Calls
extension CartEntity{

    private class func fetchCart(completion: @escaping (CartResponse) -> ()){
        Loader.show()
        CartService.shared.getCart { response in
            Loader.dismiss()
            switch response{
            case .success(let cart):
                completion(cart)
                break
            case .failure(let error):
                print(Constants.Error, error.localizedDescription)
            }
        }
    }
    
    private class func syncCart(objects: [[String:Any]]){
        CartService.shared.updateCart(body: ["items": objects]) { response in
            switch response{
            case .success(_):
                break
            case .failure(let error):
                print("Error while updating cart \(error.localizedDescription)")
            }
        }
    }
}
