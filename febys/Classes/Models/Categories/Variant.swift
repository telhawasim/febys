
import Foundation

class Variant : Codable {
    let isDefault : Bool?
    let id : String?
    let attributes : [Attributes]?
    let originalPrice : Price?
    let price : Price?
    let hasPromotion : Bool?
    let plannedPromotion : Bool?
    let promotion : Promotion?
    let images : [String]?
    let skuId : String?
    let availability : Bool?
    let packaging : Packaging?
    let fulfillmentByFebys : Bool?
    let freeDelivery : Bool?
    let refund : Refund?
    let warranty : Warranty?
    let stats : Stats?
    let discountPercentage : Double?

    enum CodingKeys: String, CodingKey {
        case isDefault = "default"
        case id = "_id"
        case attributes = "attributes"
        case originalPrice = "original_price"
        case price = "price"
        case hasPromotion = "has_promotion"
        case plannedPromotion = "planned_promotion"
        case promotion = "promotion"
        case images = "images"
        case skuId = "sku_id"
        case availability = "availability"
        case packaging = "packaging"
        case fulfillmentByFebys = "fulfillment_by_febys"
        case freeDelivery = "free_delivery"
        case refund = "refund"
        case warranty = "warranty"
        case stats = "stats"
        case discountPercentage = "discount_percentage"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        attributes = try values.decodeIfPresent([Attributes].self, forKey: .attributes)
        originalPrice = try values.decodeIfPresent(Price.self, forKey: .originalPrice)
        price = try values.decodeIfPresent(Price.self, forKey: .price)
        hasPromotion = try values.decodeIfPresent(Bool.self, forKey: .hasPromotion)
        plannedPromotion = try values.decodeIfPresent(Bool.self, forKey: .plannedPromotion)
        promotion = try values.decodeIfPresent(Promotion.self, forKey: .promotion)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        availability = try values.decodeIfPresent(Bool.self, forKey: .availability)
        packaging = try values.decodeIfPresent(Packaging.self, forKey: .packaging)
        fulfillmentByFebys = try values.decodeIfPresent(Bool.self, forKey: .fulfillmentByFebys)
        freeDelivery = try values.decodeIfPresent(Bool.self, forKey: .freeDelivery)
        refund = try values.decodeIfPresent(Refund.self, forKey: .refund)
        warranty = try values.decodeIfPresent(Warranty.self, forKey: .warranty)
        stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
        discountPercentage = try values.decodeIfPresent(Double.self, forKey: .discountPercentage)
    }
}

struct Attributes : Codable {
    var isSelected: Bool?
    let id : String?
    let name : String?
    let value : String?
    let values : [String]?
    let key : String?
    let attributes : [Attributes]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case value = "value"
        case values = "values"
        case key = "key"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let val = try decoder.container(keyedBy: CodingKeys.self)
        id = try val.decodeIfPresent(String.self, forKey: .id)
        name = try val.decodeIfPresent(String.self, forKey: .name)
        value = try val.decodeIfPresent(String.self, forKey: .value)
        values = try val.decodeIfPresent([String].self, forKey: .values)
        key = try val.decodeIfPresent(String.self, forKey: .key)
        attributes = try val.decodeIfPresent([Attributes].self, forKey: .attributes)
    }
}

struct Descriptions : Codable {
    let title : String?
    let content : String?
    let id : String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case content = "content"
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}

struct Category : Codable {
    let id : Int?
    let name : String?
}
