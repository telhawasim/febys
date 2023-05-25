import Foundation

struct Filters : Codable {
	let attributes : Attributes?
	let vendors : VendorListing?
	let priceRange : Price?
	let siblingCategories : [Categories]?
	let category : Categories?
	let availableCategories : [Categories]?

	enum CodingKeys: String, CodingKey {

		case attributes = "attributes"
		case vendors = "vendors"
		case priceRange = "price_range"
		case siblingCategories = "sibling_categories"
		case category = "category"
		case availableCategories = "available_categories"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		attributes = try values.decodeIfPresent(Attributes.self, forKey: .attributes)
		vendors = try values.decodeIfPresent(VendorListing.self, forKey: .vendors)
		priceRange = try values.decodeIfPresent(Price.self, forKey: .priceRange)
		siblingCategories = try values.decodeIfPresent([Categories].self, forKey: .siblingCategories)
		category = try values.decodeIfPresent(Categories.self, forKey: .category)
		availableCategories = try values.decodeIfPresent([Categories].self, forKey: .availableCategories)
	}

}
