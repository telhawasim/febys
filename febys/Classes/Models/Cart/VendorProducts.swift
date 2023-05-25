import Foundation

struct VendorProducts : Codable {
    var vendor : Vendor?
    var products : [Products]?
    let amount : Price?
    let status : String?
    let returnFeePercentage : Int?
    let reverted : Bool?
    let id : String?
    let courier : Courier?
    let revertDetails : RevertDetails?
    var hasReviewed : Bool?
    var ratingAndReview : RatingsAndReviews?
    let returnDetails : [ReturnDetail]?


	enum CodingKeys: String, CodingKey {
		case vendor = "vendor"
		case products = "products"
        case amount = "amount"
        case status = "status"
        case returnFeePercentage = "return_fee_percentage"
        case reverted = "reverted"
        case id = "_id"
        case courier = "courier"
        case revertDetails = "revert_details"
        case hasReviewed = "hasReviewed"
        case ratingAndReview = "rating_and_review"
        case returnDetails = "returns_detail"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendor = try values.decodeIfPresent(Vendor.self, forKey: .vendor)
		products = try values.decodeIfPresent([Products].self, forKey: .products)
        amount = try values.decodeIfPresent(Price.self, forKey: .amount)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        returnFeePercentage = try values.decodeIfPresent(Int.self, forKey: .returnFeePercentage)
        reverted = try values.decodeIfPresent(Bool.self, forKey: .reverted)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        courier = try values.decodeIfPresent(Courier.self, forKey: .courier)
        revertDetails = try values.decodeIfPresent(RevertDetails.self, forKey: .revertDetails)
        hasReviewed = try values.decodeIfPresent(Bool.self, forKey: .hasReviewed)
        returnDetails = try values.decodeIfPresent([ReturnDetail].self, forKey: .returnDetails)
        ratingAndReview = try values.decodeIfPresent(RatingsAndReviews.self, forKey: .ratingAndReview)
        
	}

    func isRefundable() -> Bool {
        var isRefundable = false
        _ = self.products?.compactMap({ producs in
            if producs.refundable ?? false {
                isRefundable = true
            }
        })
        return isRefundable
    }
    
}
