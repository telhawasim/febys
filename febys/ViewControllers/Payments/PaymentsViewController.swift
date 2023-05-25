//
//  PaymentsViewController.swift
//  febys
//
//  Created by Abdul Kareem on 06/10/2021.
//



import UIKit
import PayPalCheckout
import Braintree
import BraintreeDropIn

protocol PaymentsDelegate {
    func proceedPurchase(with transactions: [Transaction])
}

class PaymentsViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: FebysLabel!
    @IBOutlet weak var payButton: FebysButton!
    
    // MARK: Properties
    let merchatBTCurrency = "GHS"
    let merchatPSCurrency = "GHS"
    var isSplitRequest = false
    var orderPurpose: String?
    var transactions : [Transaction]? = []
    var orderAmount: Price?
    var billAmount: Price?
    var delegate: PaymentsDelegate?
    var slabs : [SlabData]?
   
    private var cellData: [PaymentMethodCells] = []
    private var selectedPaymentMethod: PaymentMethodCells? {didSet{tableView.reloadData()}}
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        totalAmountLabel.text = self.orderAmount?.formattedPrice()
        
        setupButtonActions()
        configureTableView()
        fetchUserWallet()
        getFeeSlabs()
        initTransactionCallbacks()
        prepareData()
    }
    
    //MARK: IBActions
    func setupButtonActions() {
        self.payButton.didTap = { [weak self] in
            guard let self = self else { return }
            
            switch self.selectedPaymentMethod {
            case .wallet(isSplit: self.isSplitRequest):
                self.proceedWalletPayment()
           
            case .paystack(let transactionFee):
                guard var orderAmount = self.orderAmount else { return }
                orderAmount.value = self.isSplitRequest
                ? orderAmount.amountAfterDeductionForSplit.round(to: 2)
                : orderAmount.value?.round(to: 2)
                
                PurchaseService.shared.finalizePaymentRequest(merchantCurrency: self.merchatPSCurrency, orderAmount: orderAmount, transactionFee: transactionFee)
                { paymentRequest in
                    self.proceedPayStackPayment(paymentRequest: paymentRequest)

                } onFailure: { error in
                    self.showMessage(Constants.Error, error, onDismiss: nil)
                }
                

            case .braintree(let transactionFee):
                guard var orderAmount = self.orderAmount else { return }
                orderAmount.value = self.isSplitRequest
                ? orderAmount.amountAfterDeductionForSplit.round(to: 2)
                : orderAmount.value?.round(to: 2)
                
                PurchaseService.shared.finalizePaymentRequest(merchantCurrency: self.merchatBTCurrency, orderAmount: orderAmount, transactionFee: transactionFee)
                { paymentRequest in
                    self.getBrainTreeToken(paymentRequest: paymentRequest)

                } onFailure: { error in
                    self.showMessage(Constants.Error, error, onDismiss: nil)
                }

            default:
                break
            }
        }
    }
    
    //MARK: Navigation
    func goToSplitPayment() {
        let vc = UIStoryboard.getVC(from: .Payments, SplitPaymentViewController.className) as! SplitPaymentViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func goToThankYou(with id: String) {
//        let vc = UIStoryboard.getVC(from: .Payments, ThankYouViewController.className) as! ThankYouViewController
//        vc.orderId = id
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func presentPayStack(_ payStack: PayStackResponse) {
        let vc = UIStoryboard.getVC(from: .Payments, PayStackViewController.className) as! PayStackViewController
        vc.payStack = payStack
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    
    //MARK: Helpers
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PaymentTableViewCell.className)
        tableView.register(SplitDetailTableViewCell.className)
    }
    
    func updateTotalAmount(fee: Double) {
        if var totalAmount = orderAmount {
            totalAmount.value! += fee
            totalAmountLabel.text = totalAmount.formattedPrice()
        }
    }
    
    private func getFeeSlabs() {
        let currency = orderAmount?.currency
        let value = isSplitRequest
        ? self.orderAmount?.amountAfterDeductionForSplit.round(to: 2)
        : self.orderAmount?.value?.round(to: 2)
        
        var amount = Price()
        amount.currency = currency
        amount.value = value
        
        self.fetchFeeSlabs(amount: amount)
    }
    
    //MARK: PrepareData
    func prepareData() {
        cellData.removeAll()
        
        // --- WALLET
        cellData.append(.wallet(isSplit: (orderAmount?.purchaseType == .SPLIT) && (orderAmount?.isSplitAmountDeducted ?? false)))
        
        // --- SPLIT INFO
        if((orderAmount?.purchaseType == .SPLIT) && (orderAmount?.isSplitAmountDeducted ?? false)) {
            cellData.append(.splitInfo)
        }
        
        // --- PAYSTACK
        if let _ = PayStackSupportedCurrencies(rawValue:orderAmount?.currency ?? ""){ // --- Only visible when currency is supported
            cellData.append(.paystack(fee: 0.0))
        }
        
        // --- Braintree
//        cellData.append(.braintree(fee: 0.0))
        
        tableView.reloadData()
    }
    

    //MARK: Payment/Transactions
    func initTransactionCallbacks() {
        // --- onTransactionComplete
        PurchaseService.shared.onTransactionComplete = { transactionResponse in
            Loader.dismiss()
            if self.orderAmount?.purchaseType == .SPLIT {
                if self.orderAmount?.isSplitAmountDeducted ?? false{
                    self.orderAmount?.isSplitAmountDeducted = false
                    self.purchase(with: transactionResponse)
                }else{
                    self.orderAmount?.isSplitAmountDeducted = true
                    self.prepareData()
                    self.getFeeSlabs()
                    let amountAfterDeduction = self.orderAmount?.amountAfterDeductionForSplit ?? 0.0
                    self.orderAmount?.amountToDeductForSplit = amountAfterDeduction
                    self.transactions?.append(transactionResponse.transaction!)
                }
            } else {
                self.purchase(with: transactionResponse)
            }
        }
        
        // --- onTransactionFailure
        PurchaseService.shared.onTransactionFailure = { error in
            Loader.dismiss()
            self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
        }
    }
    
    func purchase(with transactionResponse: TransactionResponse?) {
        if let response = transactionResponse {
            self.transactions?.append(response.transaction!)
        }
        if let transactions = self.transactions {
            self.delegate?.proceedPurchase(with: transactions)
        }
    }
    
    //MARK: WALLET
    func proceedWalletPayment() {
        if let wallet = UserInfo.fetch()?.wallet,
           let billAmount = self.orderAmount?.value {
            if billAmount <= (wallet.convertedBalance ?? 0.0) {
                isSplitRequest = false
                transactionThroughWallet()
            } else {
                // Split payment alert
                isSplitRequest = true
                self.orderAmount?.purchaseType = .SPLIT
                self.orderAmount?.isSplitAmountDeducted = false
                self.goToSplitPayment()
            }
        }
    }
    
    func transactionThroughWallet() {
        if isSplitRequest {
            let walletBalance = UserInfo.fetch()?.wallet?.convertedBalance?.round(to: 2)
            let totalBill = self.orderAmount?.value?.round(to: 2)
            
            let transactionAmount = min(totalBill ?? 0.0, walletBalance ?? 0.0)
            let remainingAmount = (totalBill ?? 0.0) - transactionAmount
            
            self.orderAmount?.amountToDeductForSplit = transactionAmount
            self.orderAmount?.amountAfterDeductionForSplit = remainingAmount
            
            var billAmount = Price()
            billAmount.value = transactionAmount
            billAmount.currency = self.orderAmount?.currency
            
            PurchaseService.shared.transactionThroughWallet(amount: billAmount, purpose: orderPurpose)
        }
        else {
            PurchaseService.shared.transactionThroughWallet(amount: orderAmount, purpose: orderPurpose)
        }
    }
    
    //MARK: PAYSTACK
    func proceedPayStackPayment(paymentRequest: PaymentRequest){
        var request = paymentRequest
        request.purpose = self.orderPurpose
        
        Loader.show()
        PurchaseService.shared.initiatePayStackPayment(request) { response in
            Loader.dismiss()
            switch response{
            case .success(let paystackResponse):
                self.presentPayStack(paystackResponse)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                break
            }
        }
    }
    
    //MARK: BRAINTREE
    func getBrainTreeToken(paymentRequest: PaymentRequest){
        PurchaseService.shared.getBrainTreeToken { response in
            switch response {
            case .success(let token):
                self.showDropIn(clientTokenOrTokenizationKey: token, paymentRequest: paymentRequest)
            case .failure(let error):
                print("BraintreeTokenError: \(error.localizedDescription)")
            }
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String, paymentRequest: PaymentRequest) {

        let request =  BTDropInRequest()
        
        //---> Enable/Disable Paypal
        let currency = paymentRequest.requestedCurrency ?? Defaults.currency
        if (PayPalService.supportedCurrencies.contains(where: {$0.caseInsensitiveCompare(currency) == .orderedSame})){
            request.paypalDisabled = false
        } else {
            request.paypalDisabled = true
        }

        
        let uiCustomization = BTDropInUICustomization(colorScheme: .light)
        uiCustomization.fontFamily = "Helvetica"
        uiCustomization.boldFontFamily = "Helvetica Bold"
        request.uiCustomization = uiCustomization

        let amount = paymentRequest.billingAmount?.currencyFormattedString()
        let threeDSecureRequest = BTThreeDSecureRequest()
        threeDSecureRequest.amount = PurchaseService.shared.decimal(with: amount!)
        threeDSecureRequest.versionRequested = .version2
        request.threeDSecureRequest = threeDSecureRequest
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            
            if (error != nil) {
                print(error?.localizedDescription ?? "Something went wrong")
                
            } else if (result?.isCanceled == true) {
                print("CANCELED")
                
            } else if let result = result {
                let paymentNonce = result.paymentMethod?.nonce ?? ""
                var request = paymentRequest
                request.nonce = paymentNonce
                request.purpose = self.orderPurpose
                request.deviceData = PPDataCollector.collectPayPalDeviceData()

                PurchaseService.shared.transactionThroughBraintree(request)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    //MARK: PAYPAL
    private func createNewOrder() -> OrderRequest {
        let amount = PurchaseService.shared.createBillAmount(self.orderAmount)
        let currencyCode = amount.getPayPalCurrenyIfSupported ?? .usd
        let purchaseUnit = PurchaseUnit(amount: PurchaseUnit.Amount(currencyCode: currencyCode, value: "\(amount.value?.round(to: 2) ?? 0.0)"))
        return OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])
    }
    
    func presentPaypalBottomSheet() {
        let order = createNewOrder()
        Checkout.start(
            createOrder: { action in
                action.create(order: order) { orderId in
                    if orderId == nil {
                        print("There was an error with the format of your order object")
                    } else {
                        print("Order created with order ID \(orderId ?? "")")
                    }
                }
            },
            onApprove: { approval in
                print("Checkout Approved")
                self.proceedPaypalPayment(approval: approval)
            },
            onCancel: {
                print("Checkout cancelled")
            },
            onError: { errorInfo in
                print("Checkout failed with error info \(errorInfo.error.localizedDescription)")
            }
        )
    }
    
    func proceedPaypalPayment(approval: Approval) {
        Loader.show()
        PayPalService.shared.processOrderActions(with: approval) { response in
            Loader.dismiss()
            switch response {
            case .success(let order):
                self.transactionWithPaypal(with: order.id)
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                break
            }
        }
    }
    
    func transactionWithPaypal(with orderId: String) {
        Loader.show()
        PurchaseService.shared.transactionThroughPaypal(orderId: orderId, purpose: orderPurpose ?? "")
    }
    
    
    //MARK: API Callings
    func fetchUserWallet() {
        WalletService.shared.fetchUserWallet { response in
            switch response {
            case .success(let walletResponse):
                var userInfo = UserInfo.fetch()
                userInfo?.wallet = walletResponse.wallet
                _ = userInfo?.save()
                self.convertWalletCurrency()
                break
            case .failure(let error):
                print("WalletError: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func convertWalletCurrency() {
        PurchaseService.shared.convertWalletIntoCurrent(currency: self.orderAmount?.currency ?? "GHS") { (currency, balance) in
            var userInfo = UserInfo.fetch()
            userInfo?.wallet?.convertedCurrency = currency
            userInfo?.wallet?.convertedBalance = Double(balance)
            _ = userInfo?.save()
            self.tableView.reloadData()
        }
    }
    
    func fetchFeeSlabs(amount: Price){
        let bodyParams = ["amount" : "\(amount.value ?? 0.0)",
                          "currency" : amount.currency ?? "GHS"] as [String : Any]
        
        Loader.show()
        PurchaseService.shared.fetchTransactionFeeSlabs(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let slabs):
                self.slabs = slabs.programs
                self.tableView.reloadData()
            case .failure(let error):
                print("FeeSlabsError: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: SplitPaymentDelegate
extension PaymentsViewController: SpitPaymentDelegate {
    func didTapSplit() {
        self.transactionThroughWallet()
    }
    
    func didTapCancel() {
        self.isSplitRequest = false
    }
}

//MARK: UITableView
extension PaymentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellData[indexPath.row]
        switch cellType {
        case .wallet(let isSplited):
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.className) as! PaymentTableViewCell
            let isSelected = selectedPaymentMethod == cellType
            cell.configure(.WALLET(isSplited ? true : isSelected, isSplited))
            return cell
            
        case .splitInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: SplitDetailTableViewCell.className) as! SplitDetailTableViewCell
            cell.configure(with: self.orderAmount)
            return cell
            
        case .paystack:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.className) as! PaymentTableViewCell
            let isSelected = selectedPaymentMethod == cellType
            let feeSlab = self.slabs?.first(where:{$0.gateway == "PAYSTACK"})
            cell.configure(.PAYSTACK(isSelected, feeSlab?.slab))
            return cell
            
        case .braintree:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.className) as! PaymentTableViewCell
            let isSelected = selectedPaymentMethod == cellType
            let feeSlab = self.slabs?.first(where:{$0.gateway == "BRAINTREE"})
            cell.configure(.BRAINTREE(isSelected, feeSlab?.slab))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cellData[indexPath.row]
        switch cellType {
        case .wallet(let isSplit):
            self.selectedPaymentMethod = .wallet(isSplit: isSplit)
            self.updateTotalAmount(fee: Defaults.double)
            break
        case .paystack:
            let feeSlab = self.slabs?.first(where:{$0.gateway == "PAYSTACK"})
            let paystack = PaymentMethodCells.paystack(fee: feeSlab?.slab?.value ?? 0.0)
            cellData[indexPath.row] = paystack
            self.selectedPaymentMethod = paystack
            self.updateTotalAmount(fee: feeSlab?.slab?.value ?? Defaults.double)
            break
        case .braintree:
            let feeSlab = self.slabs?.first(where:{$0.gateway == "BRAINTREE"})
            let paypal = PaymentMethodCells.braintree(fee: feeSlab?.slab?.value ?? 0.0)
            cellData[indexPath.row] = paypal
            self.selectedPaymentMethod = paypal
            self.updateTotalAmount(fee: feeSlab?.slab?.value ?? Defaults.double)
            break
        default:
            break
        }
    }
}

//MARK: Enums
fileprivate enum PaymentMethodCells: Equatable {
    case wallet(isSplit: Bool)
    case splitInfo
    case paystack(fee: Double)
    case braintree(fee: Double)
}

enum PaymentMethod {
    case WALLET(Bool, Bool)
    case BRAINTREE(Bool, Slab?)
    case PAYSTACK(Bool, Slab?)
}

enum SlabType : String {
    case PERCENTAGE = "PERCENTAGE"
    case FIXED = "FIXED"
    case BOTH = "BOTH"
}

enum PurchaseType {
    case TOPUP
    case SPLIT
}
