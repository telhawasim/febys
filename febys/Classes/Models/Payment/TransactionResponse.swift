import Foundation

struct TransactionResponse : Codable {
    let transaction : Transaction?
    var listing : TransactionListing?

    enum CodingKeys: String, CodingKey {
        case transaction = "transaction"
        case listing = "listing"
    }
}

struct Transaction : Codable {
    let userId : String?
    let requestedCurrency : String?
    let requestedAmount : Double?
    let conversionRate : Double?
    let billingCurrency : String?
    let billingAmount : Double?
    let source : String?
    let status : String?
    let purpose : String?
    let id : String?
    let createdAt : String?
    let updatedAt : String?
    let walletBalanceBefore : Double?
    let walletBalanceAfter : Double?
    let walletCurrency : String?
    let externalRefNo : String?
    
    let paymentMethod : String?
    let transactionFee : Double?
    let transactionFeeInfo : TransactionFeeInfo?
    

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case requestedCurrency = "requested_currency"
        case requestedAmount = "requested_amount"
        case conversionRate = "conversion_rate"
        case billingCurrency = "billing_currency"
        case billingAmount = "billing_amount"
        case source = "source"
        case status = "status"
        case purpose = "purpose"
        case id = "_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case walletBalanceBefore = "wallet_balance_before"
        case walletBalanceAfter = "wallet_balance_after"
        case walletCurrency = "wallet_currency"
        case externalRefNo = "external_ref_no"
        case paymentMethod = "payment_method"
        case transactionFee = "transaction_fee"
        case transactionFeeInfo = "transaction_fee_info"
    }
}

struct TransactionFeeInfo : Codable {
    let currency : String?
    let from : Double?
    let to : Double?
    let type : String?
    let percentage : Double?
    let fixed : Double?
    let value : Double?
    let id : String?

    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case from = "from"
        case to = "to"
        case type = "type"
        case percentage = "percentage"
        case fixed = "fixed"
        case value = "value"
        case id = "_id"
    }
}
