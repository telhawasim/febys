//
//  CartDatasource.swift
// CoreDataMVC
//
//  Created by Arun Jangid on 01/05/20.
//

import UIKit
import CoreData

protocol RefreshViews: AnyObject {
    func deleteRows(forindexPath indexPath:IndexPath)
    func updateRows(forindexPath indexPath:IndexPath)
}

protocol CartDelegate {
    func didTapVendorDetail(of vendorId: String)
}

class CartDatasource: NSObject, UITableViewDataSource {

    var _fetchedResultsController: NSFetchedResultsController<CartEntity>? = nil
    var managedObjectContext :NSManagedObjectContext = DatabaseManager.persistentContainer.viewContext
    
    weak var delegate:RefreshViews?
    var cartDelegate:CartDelegate?
    var didTapCross :((String, Int) -> ())?

    var fetchedResultsController: NSFetchedResultsController<CartEntity> {
    
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
                        
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
                        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "vendorId", cacheName: nil)
                
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, customCellForRowAt: indexPath, forCart: true)
    }
   
    func tableView(_ tableView: UITableView, viewForCartItemHeaderInSection section: Int, forCart: Bool) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingCartHeader.className) as! ShoppingCartHeader
   
        let header = self.fetchedResultsController.sections?[section].objects?.first as? CartEntity
        
        view.headerTitle.text = header?.storeName ?? ""
        view.headerRole.text = header?.vendorRole ?? ""
        if let url = header?.storeImage { view.headerImage.setImage(url: url) }
        else { view.headerImage.image = UIImage(named: "user.png") }
        view.configure(forCart: forCart)
        
        view.vendorDetailButton.didTap = { [weak self] in
            self?.cartDelegate?.didTapVendorDetail(of: header?.vendorId ?? "")
        }
        return view
    }
       
    func tableView(_ tableView: UITableView, viewForCartItemFooterInSection section: Int, onDownloadClick: (() -> Void)? = nil) -> UIView? {
        if section == ((self.fetchedResultsController.sections?.count ?? 0) - 1) {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingCartFooter.className) as! ShoppingCartFooter

            view.downloadPDFButton.didTap = {
                onDownloadClick?()
            }
            
            return view
        }
       return nil
    }
    
    func tableView(_ tableView: UITableView, customCellForRowAt indexPath: IndexPath, forCart isForCart: Bool) -> UITableViewCell {
        
        var cart: CartEntity!
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCell.className, for: indexPath) as! ShoppingCartCell
        
        cart = self.fetchedResultsController.object(at: indexPath)
        cell.configureForWishlist(id: cart.skuId ?? "")
        cell.configureForCart(cart)

        cell.cartCrossBtn.didTap = { [weak self] in
            self?.didTapCross?(cart.skuId ?? "", 0)
        }
        cell.increaseQuantityButton.didTap = {
            cart.quantity += 1
            CartEntity.updateCart(product: cart.skuId ?? "", forQuantity: Int(cart.quantity))
        }
        cell.decreaseQuantityButton.didTap = {
            cart.quantity -= 1
            CartEntity.updateCart(product: cart.skuId ?? "", forQuantity: Int(cart.quantity))
        }
        
        return cell
    }
}

extension CartDatasource: NSFetchedResultsControllerDelegate{
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            delegate?.deleteRows(forindexPath: indexPath!)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        case .update:
            delegate?.updateRows(forindexPath: indexPath!)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        default:
            break
        }
    }
}
