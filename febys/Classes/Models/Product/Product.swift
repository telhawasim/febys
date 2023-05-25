import Foundation

struct ProductDetailResponse : Codable {
    let product : Product?
}

class Product: Codable {
    let variant: Variant? // --- Just for shopping cart model
    
    let id : String?
    let vendorId : String?
    let active : Bool?
    let brief : String?
    let categoryActive : Bool?
    let categoryId : Int?
    let createdAt : String?
    let descriptions : [Descriptions]?
    let name : String?
    let updateProduct : Bool?
    let updatedAt : String?
    let variants : [Variant]?
    let vendorActive : Bool?
    let vendor : Vendor?
    var questionAnswers : [QnAThread]?
    var ratingsAndReviews : [RatingsAndReviews]?
    let scores : [Score]?
    let stats : Stats?
    let vendorShopName: String?


    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case vendorId = "vendor_id"
        case active = "active"
        case brief = "brief"
        case categoryActive = "category_active"
        case categoryId = "category_id"
        case createdAt = "created_at"
        case descriptions = "descriptions"
        case name = "name"
        case updateProduct = "update_product"
        case updatedAt = "updated_at"
        case variants = "variants"
        case vendorActive = "vendor_active"
        case vendor = "vendor"
        case questionAnswers = "question_answers"
        case ratingsAndReviews = "ratings_and_reviews"
        case scores = "scores"
        case stats = "stats"
        case vendorShopName = "vendor_shop_name"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        vendorId = try values.decodeIfPresent(String.self, forKey: .vendorId)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        brief = try values.decodeIfPresent(String.self, forKey: .brief)
        categoryActive = try values.decodeIfPresent(Bool.self, forKey: .categoryActive)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        descriptions = try values.decodeIfPresent([Descriptions].self, forKey: .descriptions)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updateProduct = try values.decodeIfPresent(Bool.self, forKey: .updateProduct)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        variants = try values.decodeIfPresent([Variant].self, forKey: .variants)
        vendorActive = try values.decodeIfPresent(Bool.self, forKey: .vendorActive)
        vendor = try values.decodeIfPresent(Vendor.self, forKey: .vendor)
        questionAnswers = try values.decodeIfPresent([QnAThread].self, forKey: .questionAnswers)
        ratingsAndReviews = try values.decodeIfPresent([RatingsAndReviews].self, forKey: .ratingsAndReviews)
        scores = try values.decodeIfPresent([Score].self, forKey: .scores)
        stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
        vendorShopName = try values.decodeIfPresent(String.self, forKey: .vendorShopName)
        
        variant = nil
    }
    
    func byMostRecent() {
        self.ratingsAndReviews?.sort(by: { ($0.createdAt ?? "") > ($1.createdAt ?? "") })
    }

    func byRating(accending: Bool = false) {
        if accending {
            self.ratingsAndReviews?.sort(by: { ($0.score ?? 0.0) < ($1.score ?? 0.0) })
        } else {
            self.ratingsAndReviews?.sort(by: { ($0.score ?? 0.0) > ($1.score ?? 0.0) })
        }
    }
}
        
