//
//  CheckoutViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 15/09/2021.
//

import UIKit
import CoreData

enum CheckoutSection {
    case address(String, String)
    case shipping(String, String)
    case title(String)
    case vendor(VendorProducts)
    case voucher(Voucher?)
    case summary(Order?)
}

class CheckoutViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var totalAmountLabel: FebysLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeOrderButton: FebysButton!
    
    //MARK: Properties
    private var debouncer: Debouncer!
    
    var orderInfo: OrderResponse?
    var selectedAddress: ShippingDetail?
    var voucher: Voucher?
    var messages: [Message] = []
    var summaryHeight: CGFloat?
    var checkoutSections = [CheckoutSection]()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        debouncer = Debouncer.init(delay: 1, callback: performNetworkCall)
        setupButtons()
        configureTableView()
        
        if let address = ShippingDetails.fetch()?.shippingDetail {
            selectedAddress = address
            fetchOrderDetail()
        }
    
        prepareData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddressUpdated), name: .addressUpdated, object: nil)
        
    }
    
    //MARK: Setup Buttons
    func setupButtons() {
        placeOrderButton.didTap = { [weak self] in
            guard let self = self else {return}
            if let _ = self.selectedAddress, let _ = self.orderInfo?
                .order?.swooveEstimates?.responses?.selectedEstimate {
                
                self.goToPaymentProcessing()
                
            } else if self.selectedAddress == nil {
                self.showMessage(Constants.Error, Constants.selectAddressForEstimate, onDismiss: nil)
            } else {
                self.showMessage(Constants.Error, Constants.selectEstimate, onDismiss: nil)

            }
        }
    }
    
    //MARK: Configure
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top:-10, left:0, bottom:40, right:0)
        
        tableView.register(CheckoutTableViewCell.className)
        tableView.register(OrderLabelCell.className)
        tableView.register(ShoppingCartCell.className)
        tableView.register(VoucherViewCell.className)
        tableView.register(SummaryDetailViewCell.className)
        tableView.registerHeaderFooter(ShoppingCartHeader.className)
        tableView.registerHeaderFooter(MessageFooter.className)
    }
    
    //MARK: Prepare Data
    func prepareData() {
        self.checkoutSections.removeAll()
        
        // ===> Shipping Address
        let addressStr = generateAddressString(selectedAddress?.address)
        let address = (addressStr?.isEmpty ?? false)
        ? Constants.selectAddress : addressStr!
        
        checkoutSections.append(
            .address(Constants.shippingAddress, address)
        )
        
        // ===> Shipping Method
        processSwooveResponse(orderInfo?.order?.swooveEstimates) { estimateStr in
            self.checkoutSections.append(
                .shipping(Constants.shippingMethod, estimateStr ?? "Select \(Constants.shippingMethod)")
            )
        }
        
        // ===> Order Label
        checkoutSections.append(
            .title("Orders")
        )
        
        
        // ===> Vendor Products
        if let vendors = orderInfo?.order?.vendorProducts {
            vendors.forEach { vendor in
                checkoutSections.append(.vendor(vendor))
            }
        }
        
        // ===> Add Voucher
        checkoutSections.append(
            .voucher(voucher)
        )
        
        // ===> Order Summary
        checkoutSections.append(
            .summary(orderInfo?.order)
        )
        
        self.tableView.reloadData()
        self.updateTotalPrice()
    }
    
    func prepareMessages() -> [[String : Any]]? {
        var dictionaryArray = [[String:Any]]()
        _ = messages.compactMap { item in
            let newItem = ["vendor_id": item.vendorId ?? "",
                           "message": item.message ?? ""] as [String : Any]
            dictionaryArray.append(newItem)
        }
        return dictionaryArray
    }
    
    func prepareCartItems(of orderInfo: Order?) -> [[String : Any]] {
        var itemsDictionary = [[String:Any]]()
        _ = orderInfo?.vendorProducts?.compactMap { vendors in
            _ = vendors.products?.compactMap({ product in
                let newItem = [ParameterKeys.qty:product.qty ?? 0,
                               ParameterKeys.sku_id:product.product?.variants?.first?.skuId ?? ""] as [String : Any]
                itemsDictionary.append(newItem)
            })
        }
        return itemsDictionary
    }
    
    func getTransactionIds(of order: Order?) -> [String] {
        var ids: [String] = []
        _ = order?.transactions?.compactMap({ transaction in
            ids.append(transaction.id ?? "")
        })
        return ids
    }
    
    
    //MARK: Methods
    func processSwooveResponse(_ response: SwooveEstimates?, onCompletion: @escaping ((String?)->()) ) {
        
        guard let response = response else {
            onCompletion(nil)
            return
        }

        if let success = response.success, let _ = response.code {
    
            if success {
                if let selectedEstimate = response.responses?.selectedEstimate {
                    onCompletion(generateEstimateString(selectedEstimate))
                }
                else if let optimal = response.responses?.optimalEstimate, let optimalEstimate = response.responses?.estimates?.first(where: {$0.estimateId == optimal.estimateId}) {
                    
                    onCompletion(generateEstimateString(optimalEstimate))
                    orderInfo?.order?.swooveEstimates?.responses?.selectedEstimate = optimalEstimate
                }
            } else {
                onCompletion(nil)
                showMessage(Constants.Error,
                            response.message ?? Constants.estimateError,
                            onDismiss: nil)
            }
        }
    }
    
    func generateEstimateString(_ estimate: Estimate) -> String? {
        var price = Price()
        price.currency = estimate.totalPricing?.currencyCode ?? Defaults.currency
        price.value = estimate.totalPricing?.value ?? Defaults.double

        var string = ""
        string += estimate.estimateTypeDetails!.name!
        string += " - "
        string += price.formattedPrice()!
        string += "\n"
        string += estimate.timeString!
        
        orderInfo?.order?.shippingFee = price
        return string
    }
    
    func generateAddressString(_ address: Address?) -> String? {
        var addressString = ""

        if let street = address?.street { addressString += "\(street)" }
        if let city = address?.city { addressString += ", \(city)" }
        if let state = address?.state { addressString += ", \(state)" }
        if let zipCode = address?.zipCode { addressString += ", \(zipCode)" }
        if let country = address?.countryCode { addressString += ", \(country)." }
        
        return addressString
    }
    
    func validateVoucher(field: FebysTextField) -> Bool {
        guard let voucher = field.text?.trim() else {
            return false
        }
        var errorMessage : String?
        
        if voucher.isEmpty{
            errorMessage = "\(Constants.VoucherCode) \(Constants.IsRequired)"
        }
        
        if let errorMxg = errorMessage {
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    func voucherApplicable(minAmount: Double, orderAmount: Double) -> Bool {
        if orderAmount < minAmount {
            self.showMessage(Constants.Error, Constants.voucherAmountNotMinimum, onDismiss: nil)
            return false
        }
        return true
    }
        
    func updateOrder(with order: OrderResponse?) {
        self.orderInfo = order
        self.prepareData()
    }
    
    func updateTotalPrice() {
        if var billAmount = orderInfo?.order?.billAmount {
            if let shippingFee = orderInfo?.order?.shippingFee {
                billAmount.value! += shippingFee.value!
                self.totalAmountLabel.text = billAmount.formattedPrice()
            } else {
                self.totalAmountLabel.text = billAmount.formattedPrice()
            }
        }
    }
    
    @objc func handleAddressUpdated(notification: NSNotification) {
        if let address = notification.object as? ShippingDetails {
            selectedAddress = address.shippingDetail
            fetchOrderDetail()
        }
    }
    
    //MARK: Dismiss Contolller
    func dismiscontroller(completion: @escaping (Bool)->Void){
        var totalCount = 0
        _ = orderInfo?.order?.vendorProducts?.compactMap({ vendors in
            vendors.products?.compactMap({ product in
                totalCount += (product.qty ?? 0)
            })
        })
        
        if totalCount < 1 {
            completion(true)
            self.backButtonTapped(self)
        } else {
            completion(false)
        }
    }
    
    //MARK: Present PopUp
    func presentAddressChangePopup() {
        self.showMessage(Constants.Shipping, Constants.shippingAddressChange, messageImage: .location, isQuestioning: true, onSuccess: {
            self.goToShippingAddress()
        },onDismiss: nil)
    }
    
    //MARK: Navigation
    func goToShippingAddress() {
        let vc = UIStoryboard.getVC(from: .ShippingAddress, ShippingAddressViewController.className) as! ShippingAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func goToShippingMethods(_ response: SwooveResponse) {
        let vc = UIStoryboard.getVC(from: .ShoppingCart, ShippingMethodsViewController.className) as! ShippingMethodsViewController
        vc.delegate = self
        vc.swooveResponse = response
        vc.selectedEstimate = orderInfo?.order?.swooveEstimates?.responses?.selectedEstimate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToThankYou(with id: String) {
        let vc = UIStoryboard.getVC(from: .Payments, ThankYouViewController.className) as! ThankYouViewController
        vc.orderId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToPaymentProcessing() {
        var orderAmount = orderInfo?.order?.billAmount
        let shippingFee = orderInfo?.order?.shippingFee
        orderAmount?.value! += shippingFee!.value!

        let vc = UIStoryboard.getVC(from: .Payments, PaymentsViewController.className) as! PaymentsViewController
        vc.orderPurpose = Constants.PRODUCT_PURCHASE
        vc.orderAmount = orderAmount
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetail(productId: String, skuId: String) {
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.preferredSkuId = skuId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ShippingEstimate Delegate
extension CheckoutViewController: ShippingMethodDelegate {
    func didSelectShippingMethod(_ estimate: Estimate) {
        orderInfo?.order?.swooveEstimates?.responses?.selectedEstimate = estimate
        prepareData()
    }
}


//MARK: PaymentsDelegate
extension CheckoutViewController: PaymentsDelegate {
    func proceedPurchase(with transactions: [Transaction]) {
        var orderInfo = self.orderInfo
        orderInfo?.order?.voucher = self.voucher
        orderInfo?.order?.shippingDetail = self.selectedAddress
        orderInfo?.order?.transactions = transactions
        
        self.placeOrder(order: orderInfo?.order, items: self.prepareCartItems(of: orderInfo?.order), messages: self.prepareMessages())
    }
}

//MARK: MessageDelegate
extension CheckoutViewController: MessageDelegate {
    func messageDidChange(_ message: String, forVendor id: String) {
        if let i = messages.firstIndex(where: { $0.vendorId == id}) {
            self.messages[i].message = message
        } else {
            var msg = Message()
            msg.message = message
            msg.vendorId = id
            self.messages.append(msg)
        }
    }
}

//MARK: UITableView
extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checkoutSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch checkoutSections[section] {
        case .vendor(let vendorProducts):
            return vendorProducts.products?.count ?? 0
        default:
            return 1
        }
    }
    
    //MARK: sectionHeaderView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch checkoutSections[section] {
        case .vendor(_):
            return 55.0
        default:
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch checkoutSections[section] {
        case .vendor(let vendorProducts):
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingCartHeader.className) as! ShoppingCartHeader
            header.configure(with: vendorProducts.vendor, forCart: true)
            header.vendorDetailButton.didTap = { [weak self] in
                self?.goToVendorDetail(of: vendorProducts.vendor?.id ?? "")
            }
            
            return header
            
        default:
            return nil
        }
    }

    //MARK: sectionFooterView
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch checkoutSections[section] {
        case .vendor(_):
            return 162.0
        default:
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch checkoutSections[section] {
        case .vendor(let vendorProducts):
            
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: MessageFooter.className) as! MessageFooter

            let vendor = vendorProducts.vendor
            footer.delegate = self
            footer.configure(vendor?.id)
            
            for message in self.messages {
                if message.vendorId == footer.vendorId {
                    footer.messageField.text = message.message
                }
            }
            
            return footer
            
        default:
            return nil
        }

    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch checkoutSections[indexPath.section] {
        case .address(let title, let description):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.className, for: indexPath) as! CheckoutTableViewCell
            cell.configure(title: title, description: description)
            return cell
            
        case .shipping(let title, let description):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.className, for: indexPath) as! CheckoutTableViewCell
            cell.configure(title: title, description: description)
            return cell
            
        case .title(let title):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderLabelCell.className, for: indexPath) as! OrderLabelCell
            cell.configure(title: title)
            return cell
            
        case .vendor(let vendorProducts):
            
            let item = vendorProducts.products?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCell.className, for: indexPath) as! ShoppingCartCell
            
            cell.configureForCheckout(item?.product, qty: item?.qty)
            
            cell.increaseQuantityButton.didTap = { [weak self] in
                self?.updateRow(vendorId: vendorProducts.vendor?.id ?? "", productId: item?.product?.id ?? "", with: .increment)
            }
            
            cell.decreaseQuantityButton.didTap = { [weak self] in
                self?.updateRow(vendorId: vendorProducts.vendor?.id ?? "", productId: item?.product?.id ?? "", with: .decrement)
            }
            
            cell.cartCrossBtn.didTap = { [weak self] in
                self?.showMessage(Constants.areYouSure, Constants.youWantToRemove, messageImage: .delete, isQuestioning: true, onSuccess: {
                    self?.deleteRows(vendorId: vendorProducts.vendor?.id ?? "", productId: item?.product?.id ?? "")
                }, onDismiss: nil)
            }
            
            return cell
            
            
        case .voucher(let voucher):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: VoucherViewCell.className, for: indexPath) as! VoucherViewCell
            cell.configure(voucher)
            
            cell.applyButton.didTap = { [weak self] in
                
                guard let self = self else { return }
                if let _ = voucher {
                    self.showMessage(Constants.areYouSure, Constants.youWantToRemoveVoucher, messageImage: .delete, isQuestioning: true,
                    onSuccess: {
                        
                        self.voucher = nil
                        self.fetchOrderDetail()
                        
                    }, onDismiss: nil)
                    
                } else {
                    if self.validateVoucher(field: cell.voucherTextField) {
                        self.fetchAndValidateVoucher(code: cell.voucherTextField.text?.trim() ?? "")
                        self.tableView.reloadData()
                    }
                }
                
            }
            
            return cell
            
        case .summary(let orderInfo):
        
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryDetailViewCell.className, for: indexPath) as! SummaryDetailViewCell
            cell.configure(orderInfo)
            return cell
            
        }

    }
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch checkoutSections[indexPath.section] {
        case .address(_, _):
            
            if let _ = selectedAddress { presentAddressChangePopup() }
            else { goToShippingAddress() }
            
        case .shipping(_, _):
            
            if selectedAddress == nil {
                showMessage(Constants.Error, Constants.selectAddressForEstimate, onDismiss: nil)
            } else {
                if let response  = orderInfo?.order?.swooveEstimates?.responses{
                    goToShippingMethods(response)
                }
            }
            
        case .vendor(let vendorProducts):
            let product = vendorProducts.products?[indexPath.row].product
            self.goToProductDetail(productId: product?.id ?? "", skuId: product?.variants?.first?.skuId ?? "")
            
        default:
            break
            
        }
    }
}


//MARK: API Calling
extension CheckoutViewController {
    private func performNetworkCall() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchOrderDetail), object: nil)
        self.perform(#selector(fetchOrderDetail), with: nil, afterDelay: 0)
        self.placeOrderButton.isEnabled = true
    }
    
    @objc func fetchOrderDetail() {
        let bodyParams: [String : Any] =
        [
            ParameterKeys.items: prepareCartItems(of: self.orderInfo?.order),
            ParameterKeys.voucherCode: self.voucher?.code ?? "",
            ParameterKeys.shipping_detail: selectedAddress?.toDictionary ?? [:]
        ]
        
        
        Loader.show()
        OrderService.shared.fetchOrderInfo(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let info):
                
                if let voucher = self.voucher {
                    if self.voucherApplicable(minAmount: voucher.amount ?? Defaults.double, orderAmount: info.order?.billAmount?.value ?? Defaults.double) {
                        self.updateOrder(with: info)
                    } else {
                        self.voucher = nil
                        self.fetchOrderDetail()
                    }
                } else {
                    self.updateOrder(with: info)
                }
                
            case .failure(let error):
                self.showMessage(Constants.Sorry, error.localizedDescription, messageImage: .location, onDismiss: nil)
            }
        }
    }
    
    func fetchAndValidateVoucher(code: String) {
        Loader.show()
        VoucherService.shared.fetchVoucher(code: code) { response in
            Loader.dismiss()
            switch response {
            case .success(let voucher):
                let orderInfo = self.orderInfo?.order
                if self.voucherApplicable(minAmount: voucher.voucher?.amount ?? Defaults.double, orderAmount: orderInfo?.billAmount?.value ??  Defaults.double) {
                    self.voucher = voucher.voucher
                    self.fetchOrderDetail()
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: PLACE ORDER
    func placeOrder(order: Order?, items: [[String:Any]]?, messages: [[String:Any]]?)  {
        
        let estimate = [ParameterKeys.estimate: orderInfo?.order?.swooveEstimates?.responses?.selectedEstimate.toDictionary ?? [:]]
        
        let bodyParams=[ParameterKeys.transaction_ids:getTransactionIds(of: order),
                        ParameterKeys.items: items ?? [:],
                        ParameterKeys.messages: messages ?? [:],
                        ParameterKeys.voucherCode: order?.voucher?.code ?? "",
                        ParameterKeys.swoove: estimate,
                        ParameterKeys.shipping_detail: order?.shippingDetail?.toDictionary ?? [:]
        ] as [String : Any]
        
        Loader.show()
        OrderService.shared.placeOrder(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let orderResponse):
                CartEntity.clearAllFromCoreData(syncCart: true)
                self.goToThankYou(with: orderResponse.order?.orderId ?? "")
                
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: RefreshViews
extension CheckoutViewController {
    func deleteRows(vendorId: String, productId: String) {
        if let vendor = orderInfo?.order?.vendorProducts?.firstIndex(where: {$0.vendor?.id == vendorId}), let product = orderInfo?.order?.vendorProducts?[vendor].products?.firstIndex(where:{$0.product?.id == productId}) {
            
            self.orderInfo?.order?.vendorProducts?[vendor].products?.remove(at: product)
            
        }
        
        self.dismiscontroller { isDismissed in
            if isDismissed == false {
                self.placeOrderButton.isEnabled = false
                self.updateOrder(with: self.orderInfo)
                self.debouncer.call()
            }
        }
    }
    
    func updateRow(vendorId: String, productId: String, with update: UpdateItem) {
        
        if let vendor = orderInfo?.order?.vendorProducts?.firstIndex(where: {$0.vendor?.id == vendorId}), let product = orderInfo?.order?.vendorProducts?[vendor].products?.firstIndex(where:{$0.product?.id == productId})
        {
            
            switch update {
            case .increment:
                self.orderInfo?.order?.vendorProducts?[vendor].products?[product].qty! += 1
                
            case .decrement:
                self.orderInfo?.order?.vendorProducts?[vendor].products?[product].qty! -= 1
                
            }
        }
        
        self.dismiscontroller { isDismissed in
            if isDismissed == false {
                self.placeOrderButton.isEnabled = false
                self.updateOrder(with: self.orderInfo)
                self.debouncer.call()
            }
        }
    }
}

enum UpdateItem {
    case increment
    case decrement
}
