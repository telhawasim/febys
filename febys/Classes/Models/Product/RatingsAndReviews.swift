import Foundation

class RatingsAndReviews : Codable {
    var id : String?
    var consumerId : Int?
    var consumer : User?
    var orderId : String?
    var skuId : String?
    var productId : String?
    var review : Review?
    var score : Double?
    var upVotes : [String]?
    var downVotes : [String]?
    var updatedAt : String?
    var createdAt : String?
    var vendorId : String?
    var pricingScore : Double?
    var qualityScore : Double?
    var valueScore : Double?
    
	enum CodingKeys: String, CodingKey {
		case id = "_id"
        case consumerId = "consumer_id"
        case orderId = "order_id"
        case skuId = "sku_id"
        case consumer = "consumer"
        case productId = "product_id"
        case review = "review"
        case score = "score"
        case downVotes = "down_votes"
        case upVotes = "up_votes"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case vendorId = "vendor_id"
        case pricingScore = "pricing_score"
        case qualityScore = "quality_score"
        case valueScore = "value_score"
	}
    
    init() {}
    
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
		skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		downVotes = try values.decodeIfPresent([String].self, forKey: .downVotes)
		productId = try values.decodeIfPresent(String.self, forKey: .productId)
		review = try values.decodeIfPresent(Review.self, forKey: .review)
		score = try values.decodeIfPresent(Double.self, forKey: .score)
		upVotes = try values.decodeIfPresent([String].self, forKey: .upVotes)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		consumer = try values.decodeIfPresent(User.self, forKey: .consumer)
        vendorId = try values.decodeIfPresent(String.self, forKey: .vendorId)
        pricingScore = try values.decodeIfPresent(Double.self, forKey: .pricingScore)
        qualityScore = try values.decodeIfPresent(Double.self, forKey: .qualityScore)
        valueScore = try values.decodeIfPresent(Double.self, forKey: .valueScore)
	}
}
