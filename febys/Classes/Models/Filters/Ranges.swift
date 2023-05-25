import Foundation

struct Ranges: Codable {
    let range : Range?
    let productsCount : Int?
    let maxInclusive : Bool?

    enum CodingKeys: String, CodingKey {

        case range = "range"
        case productsCount = "products_count"
        case maxInclusive = "max_inclusive"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        range = try values.decodeIfPresent(Range.self, forKey: .range)
        productsCount = try values.decodeIfPresent(Int.self, forKey: .productsCount)
        maxInclusive = try values.decodeIfPresent(Bool.self, forKey: .maxInclusive)
    }

}
