
import Foundation
struct Suggesstion : Codable {
	let id : String?
    let skuId: String?
	let productId : String?
	let productName : String?
	let productImage : String?
	let active : Bool?
	let vendorActive : Bool?
	let categoryActive : Bool?
	let vendorId : String?
	let categoryId : Int?
	let vendorImage : String?
	let vendorName : String?
	let domain : String?
	let categoryImage : String?
	let categoryName : String?
	let hasPromotion : Bool?
	let originalPrice : Price?
	let price : Price?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
        case skuId = "sku_id"
		case productId = "product_id"
		case productName = "product_name"
		case productImage = "product_image"
		case active = "active"
		case vendorActive = "vendor_active"
		case categoryActive = "category_active"
		case vendorId = "vendor_id"
		case categoryId = "category_id"
		case vendorImage = "vendor_image"
		case vendorName = "vendor_name"
		case domain = "domain"
		case categoryImage = "category_image"
		case categoryName = "category_name"
		case hasPromotion = "has_promotion"
		case originalPrice = "original_price"
		case price = "price"
	}
}
