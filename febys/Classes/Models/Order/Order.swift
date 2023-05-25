import Foundation

struct Order : Codable {
    var id : String?
    var orderId : String?
    var consumerId : String?
    var consumer : User?
	var shippingDetail : ShippingDetail?
    var swooveEstimates : SwooveEstimates?
    var swoove : Swoove?
    var productsAmount : Price?
    var billAmount : Price?
    var deliveryFee : Price?
    var shippingFee : Price?
    var voucher : Voucher?
    var vatPercentage : Int?
    var vendorProducts : [VendorProducts]?
    var transactions : [Transaction]?
    var createdAt : String?
    
    var purchaseType: PurchaseType?
    var isSplitAmountDeducted = false
    var amountToDeductForSplit = 0.0
    var amountAfterDeductionForSplit = 0.0

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case orderId = "order_id"
		case consumerId = "consumer_id"
		case consumer = "consumer"
		case shippingDetail = "shipping_detail"
        case swooveEstimates = "swoove_estimates"
        case swoove = "swoove"
		case productsAmount = "products_amount"
        case billAmount = "bill_amount"
        case deliveryFee = "delivery_fee"
        case voucher = "voucher"
        case vatPercentage = "vat_percentage"
		case vendorProducts = "vendor_products"
		case transactions = "transactions"
        case createdAt = "created_at"
	}
    
    func getAllStatusOf() -> [OrderStatus] {
        var orderStatus: [OrderStatus] = []
        for vendor in (self.vendorProducts ?? []) {
            let status = OrderStatus(rawValue: vendor.status ?? "")
            orderStatus.append(status ?? .PENDING)
        }
        return orderStatus
    }
    
    func convertDateIntoLocal() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.UTCFormat
        return (dateFormatter.date(from: self.createdAt ?? "")?.toLocalTime())!

    }
    
    func getCurrenDateMinus(interval: Double) -> Date {
        let currentDate = Date()
        return Date(timeInterval: -interval, since: currentDate)
    }
    
    func isOrderCancelable() -> Bool {
        let interval = 1800.0 //30 Mins in Seconds
        let orderStatus = getAllStatusOf()
        let orderDate = convertDateIntoLocal()
        let currnetDate = getCurrenDateMinus(interval: interval)

        if currnetDate <= orderDate {
            if orderStatus.contains(where: [.PENDING, .ACCEPTED].contains) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

}
