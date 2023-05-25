import Foundation

class FeaturedCategoryResponse : Codable {
	let id : Int?
	let name : String?
	let logo : String?
	let featured : Int?
	let products : [Product]?
    var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case logo = "logo"
        case featured = "featured"
        case products = "products"
    }
}
