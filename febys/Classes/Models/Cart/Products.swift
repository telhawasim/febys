
import Foundation

struct Products : Codable {
    var isSelected: Bool = false
    let id : String?
	var qty : Int?
	let product : Product?
    var ratingAndReview : RatingsAndReviews?
    let refundable: Bool?

	enum CodingKeys: String, CodingKey {
        case id = "_id"
		case qty = "qty"
		case product = "product"
        case ratingAndReview = "rating_and_review"
        case refundable = "refundable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
		qty = try values.decodeIfPresent(Int.self, forKey: .qty)
		product = try values.decodeIfPresent(Product.self, forKey: .product)
        ratingAndReview = try values.decodeIfPresent(RatingsAndReviews.self, forKey: .ratingAndReview)
        refundable = try values.decodeIfPresent(Bool.self, forKey: .refundable)
	}

}
