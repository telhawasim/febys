//
//  PurchaseService.swift
//  febys
//
//  Created by Faisal Shahzad on 18/1/2022.
//

import UIKit
import CoreLocation
import SwiftUI

class PurchaseService {
    static let shared = PurchaseService()
    
    var onTransactionComplete :((TransactionResponse) -> ())?
    var onTransactionFailure : ((FebysError) -> ())?
    
    //MARK: CONVERSION
    func convertWalletIntoCurrent(currency: String, completion: @escaping ( _ success: (String,Float))->Void)  {
        let wallet = UserInfo.fetch()?.wallet
        let walletBalance = Float(wallet?.availableBalance ?? 0.0)
        let walletCurrency = wallet?.currency
        let productCurrency = currency
        
        if walletCurrency == productCurrency {
            completion((productCurrency, Float(walletBalance)))
            return
        }
        
        let bodyParams = [ParameterKeys.to: walletCurrency,
                          ParameterKeys.from: productCurrency]
        
        PriceService.shared.getConversionRate(body: bodyParams as [String : Any]) { response in
            switch response {
            case .success(let rate):
                let amount = Float(rate.conversion_rate ?? 0.0)
                let convertedAmount = walletBalance * (1/amount)
                let newConvertedAmount = (floor(convertedAmount * 100)) / 100
                
                completion((productCurrency, Float(newConvertedAmount)))
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    
//    func convertAmount(price: Price, completion: @escaping ( _ success: (Float,Float))->Void)  {
//        
//        let userWallet = Float(UserInfo.fetch()?.wallet?.availableBalance ?? 0.0)
//        let walletCurrency = UserInfo.fetch()?.wallet?.currency
//        let productCurrency = price.currency
//        
//        if walletCurrency == productCurrency {
//            completion((Float(userWallet),1))
//            return
//        }
//        
//        let bodyParams = [ParameterKeys.to: walletCurrency,
//                          ParameterKeys.from: productCurrency]
//        
//        PriceService.shared.getConversionRate(body: bodyParams as [String : Any]) { response in
//            switch response {
//            case .success(let rate):
//                let conversionRate = Float(rate.conversion_rate ?? 0.0)
//                let convertedAmount = userWallet * (1/conversionRate)
//                let newConvertedAmount = (floor(convertedAmount * 100)) / 100
//                
//                completion((Float(newConvertedAmount),conversionRate))
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    //MARK: FINALIZE PAYMENT
    func finalizePaymentRequest(merchantCurrency: String, orderAmount: Price, transactionFee: Double, onSuccess: @escaping (PaymentRequest)->(),
                                onFailure: @escaping (String)->()) {
        
        let fee = decimal(with: transactionFee.currencyFormattedString()).doubleValue
        var paymentRequest = PaymentRequest()
        
        paymentRequest.requestedCurrency = orderAmount.currency
        paymentRequest.requestedAmount = orderAmount.value?.round(to: 2)
        paymentRequest.transactionFee = fee.round(to: 2)
        
        if(orderAmount.currency != merchantCurrency) {
            
            orderAmount.currencyConversion(from: orderAmount.currency! , to: merchantCurrency) { rate in
                
                let convertedFee = transactionFee.round(to: 2) * (rate ?? 1.0)
                let convertedAmount = orderAmount.value!.round(to: 2) * (rate ?? 1.0)
                let billingAmount = convertedAmount.round(to: 2) + convertedFee.round(to: 2)
                
                let amount = self.decimal(with: billingAmount.currencyFormattedString()).doubleValue

                paymentRequest.billingCurrency = merchantCurrency
                paymentRequest.billingAmount = amount.round(to: 2)
                
                if(billingAmount.round(to: 2) <= 0.0){
                    onFailure("\(merchantCurrency)\(Constants.amountShouldBeGreater)")
                }
                
                onSuccess(paymentRequest)
            }
            
        } else {
            
            let billingAmount = orderAmount.value!.round(to: 2) + transactionFee.round(to: 2)
            
            let amount = decimal(with: billingAmount.currencyFormattedString()).doubleValue

            paymentRequest.billingCurrency = orderAmount.currency!
            paymentRequest.billingAmount = amount.round(to: 2)
            
            onSuccess(paymentRequest)
            
        }
    }
    
    func decimal(with string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as! NSDecimalNumber
    }
    
    //----> Old Implementation
    func createBillAmount(_ billAmount: Price?) -> Price {
        var amount = 0.0
        if (billAmount?.purchaseType == .SPLIT) && (billAmount?.isSplitAmountDeducted ?? false) {
            amount = billAmount?.amountAfterDeductionForSplit ?? 0.0
        }else{
            amount = billAmount?.value ?? 0.0
        }
        var price = Price()
        price.currency = billAmount?.currency ?? "GHS"
        price.value = amount.round(to: 2)
        return price
    }
    
    //MARK: FETCH SLABS
    func fetchTransactionFeeSlabs(body info: [String: Any], onComplete: @escaping ((Result<SlabsResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.transactionFeeSlabs.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) {
            (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    //MARK: WALLET
    func transactionThroughWallet(amount: Price?, purpose: String?)  {
        let bodyParams = [ParameterKeys.amount: amount?.value ?? 0.0,
                          ParameterKeys.currency: amount?.currency ?? "GHS",
                          ParameterKeys.purpose: purpose ?? ""] as [String:Any]
        
        WalletService.shared.processWalletPayment(body: bodyParams) { response in
            switch response {
            case .success(let transactionResponse):
                self.onTransactionComplete?(transactionResponse)
                break
            case .failure(let error):
                self.onTransactionFailure?(error)
            }
        }
    }
    
    //MARK: PAYSTACK
    func initiatePayStackPayment(_ request: PaymentRequest, onComplete: @escaping ((Result<PayStackResponse, FebysError>)->Void)) {
        
        let bodyParams =
        [ParameterKeys.currency: request.requestedCurrency ?? Defaults.currency,
         ParameterKeys.amount: request.requestedAmount ?? Defaults.double,
         ParameterKeys.billingCurrency: request.billingCurrency ?? Defaults.currency,
         ParameterKeys.billingAmount: request.billingAmount ?? Defaults.double,
         ParameterKeys.transactionFee: request.transactionFee ?? Defaults.double,
         ParameterKeys.purpose: request.purpose ?? ""] as [String : Any]
        
        PayStackService.shared.requestPayStack(body: bodyParams) { response in
            switch response {
            case .success(let request):
                onComplete(.success(request))
                break
            case .failure(let error):
                onComplete(.failure(error))
                break
            }
        }
    }
    
    func checkPayStackStatus(payStack: PayStackResponse?, onComplete: @escaping ((Result<String, FebysError>)->Void)){
        
        PayStackService.shared.getPayStackStatus(requestId: payStack?.transactionRequest?.reference ?? "") { response in
            switch response {
            case .success(let transactionResponse):
                if let status = transactionResponse.transaction?.status {
                    switch status {
                    case "PENDING_CLAIM":
                        self.onTransactionComplete?(transactionResponse)
                        onComplete(.success(status))
                    case "REQUESTED":
                        onComplete(.success(""))
                    default:
                        break
                    }
                }else{
                    onComplete(.success(""))
                }
                break
            case .failure(let error):
                onComplete(.failure(error))
                break
            }
        }
    }
    
    //MARK: PAYPAL
    
    func transactionThroughPaypal(orderId: String, purpose: String)  {
        
        let bodyParams = [ParameterKeys.order_id: orderId,
                          ParameterKeys.purpose: purpose] as [String : Any]
        
        PayPalService.shared.proceedPaypalPayment(body: bodyParams) { response in
            switch response {
            case .success(let transactionResponse):
                self.onTransactionComplete?(transactionResponse)
                break
            case .failure(let error):
                self.onTransactionFailure?(error)
                break
            }
        }
    }
    
    //MARK: BRAINTREE
    func transactionThroughBraintree(_ paymentRequest: PaymentRequest)  {
        let bodyParams = paymentRequest.toDictionary ?? [:]
        Loader.show()
        BraintreeService.shared.postPaymentOnBraintree(body: bodyParams) {
            response in
            Loader.dismiss()
            switch response {
            case .success(let transactionResponse):
                self.onTransactionComplete?(transactionResponse)
                break
            case .failure(let error):
                self.onTransactionFailure?(error)
                break
            }
        }
    }
    
    func getBrainTreeToken(onComplete: @escaping ((Result<String, FebysError>)->Void)) {
        Loader.show()
        BraintreeService.shared.getBraintreeToken() { response in
            Loader.dismiss()
            switch response {
            case .success(let request):
                onComplete(.success(request.transaction?.clientToken ?? ""))
                break
            case .failure(let error):
                onComplete(.failure(error))
                break
            }
        }
    }
    
}
