//
//  ShoppingCartViewController.swift
//  febys
//
//  Created by Ab Saqib on 12/08/2021.
//

import UIKit
import CoreData
import SwiftUI

class ShoppingCartViewController: BaseViewController {
    
    //MARK: IBOutlest
    @IBOutlet weak var shopCartTitleCountLabel: FebysLabel!
    @IBOutlet weak var crossButton: FebysButton!
    @IBOutlet weak var shopCartTitleLabel: FebysLabel!
    @IBOutlet weak var totalPriceLabel: FebysLabel!
    @IBOutlet weak var proceedToCheckoutButton: FebysButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    let datasource = CartDatasource()
    var vendorId = ""
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initCartCallbacks()
        updateTotalPrice()
        setupButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCartCount()
    }
    
    //MARK: Button Actions
    func setupButtonAction() {
        crossButton.didTap = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        proceedToCheckoutButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.fetchOrderDetail { orderInfo in
                    self?.goToCheckout(with: orderInfo)
                }
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
    }
    
    //MARK: Init Callback
    func initCartCallbacks() {
        self.datasource.didTapCross = { [weak self] (skuId, quantity) in
            if quantity <= 0 {
                self?.showMessage(Constants.areYouSure, Constants.youWantToRemove, messageImage: .delete, isQuestioning: true, onSuccess: {
                    CartEntity.updateCart(product: skuId, forQuantity: quantity)
                }, onDismiss: nil)
            } else {
                CartEntity.updateCart(product: skuId, forQuantity: quantity)
            }
        }
    }
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Register Cell
    func setupTableView() {
        tableView.register(ShoppingCartCell.className)
        tableView.registerHeaderFooter(ShoppingCartHeader.className)
        tableView.registerHeaderFooter(ShoppingCartFooter.className)
        
        datasource.delegate = self
        datasource.cartDelegate = self
        tableView.delegate = self
        tableView.dataSource = datasource
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    //MARK: Helper
    func configureCartCount() {
        let quantity = CartEntity.getAllCartItems()
        self.shopCartTitleCountLabel.text = "(\(quantity))"
        if quantity < 1 {
            self.proceedToCheckoutButton.isEnabled = false
        }
    }
    
    func updateTotalPrice() {
        var totalPrice = Price()
        totalPrice.value = CartEntity.cartItemsTotal()
        totalPrice.currency = CartEntity.cartItemsCurrency()
        self.totalPriceLabel.text = totalPrice.formattedPrice()
    }
    
    func updateTitleCount(){
        self.shopCartTitleCountLabel.text = "\(CartEntity.getAllCartItems())"
    }
    
    //MARK: Navigation
    func goToCheckout(with orderInfo: OrderResponse?) {
        let vc = UIStoryboard.getVC(from: .ShoppingCart, CheckoutViewController.className) as! CheckoutViewController
        vc.orderInfo = orderInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API Calling
    func fetchOrderDetail(completion: @escaping (OrderResponse)->Void) {
        let bodyParams = [ParameterKeys.items: prepareCartItems()] as [String : Any]

        proceedToCheckoutButton.isEnabled = false
        OrderService.shared.fetchOrderInfo(body: bodyParams) { response in
            DispatchQueue.main.async {
                self.proceedToCheckoutButton.isEnabled = true
            }
            switch response {
            case .success(let info):
                completion(info)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func downloadCartPDF(){
        let bodyParams = [ParameterKeys.items : prepareCartItems()]
        Loader.show()
        CartService.shared.downloadCartPDF(body: bodyParams) { responce in
            Loader.dismiss()
            switch responce{
            case .success(let cartData):
                self.saveCartPDF(pdfData: cartData)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func saveCartPDF(pdfData: Data){
        FilesManager.shared.savePdf(pdfData: pdfData, fileName: "Cart") { response in
            switch response {
            case .success((_, _)):
                self.showMessage(Constants.congratulation, Constants.pdfDownloadSuccess, messageImage: .pdf, onDismiss: nil)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: Configure Data
    func prepareCartItems() -> [[String : Any]] {
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
            return dictionaryArray
        } catch {
            print("Could not fetch all cart items")
        }
        return [[:]]
    }
}

//MARK: UITableView
extension ShoppingCartViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return datasource.tableView(tableView, viewForCartItemHeaderInSection: section, forCart: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        return datasource.tableView(tableView, viewForCartItemFooterInSection: section) { [weak self] in
            self?.showMessage(Constants.areYouSure, Constants.youWantToDownloadPDF, messageImage: .pdf, isQuestioning: true, onSuccess: {
                self?.downloadCartPDF()
            }, onDismiss: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource.fetchedResultsController.object(at: indexPath)
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.preferredSkuId = item.skuId ?? ""
        vc.productId = item.productId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Refresh Views
extension ShoppingCartViewController: CartDelegate{
    func didTapVendorDetail(of vendorId: String) {
        self.goToVendorDetail(of: vendorId)
    }
}

//MARK: Refresh Views
extension ShoppingCartViewController: RefreshViews{
    func deleteRows(forindexPath indexPath: IndexPath) {
        self.tableView.reloadData()
        updateTotalPrice()
        updateTitleCount()
        configureCartCount()
    }
    
    func updateRows(forindexPath indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateTotalPrice()
            self.updateTitleCount()
            self.configureCartCount()
        }
    }
}

//MARK: Download Pdf Method
extension ShoppingCartViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
    }
}
