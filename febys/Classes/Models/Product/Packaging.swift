
import Foundation

struct Packaging : Codable {
    let id : String?
    let weight : Double?
    let width : Double?
    let length : Double?
    let height : Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case weight = "weight"
        case width = "width"
        case length = "length"
        case height = "height"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        weight = try values.decodeIfPresent(Double.self, forKey: .weight)
        width = try values.decodeIfPresent(Double.self, forKey: .width)
        length = try values.decodeIfPresent(Double.self, forKey: .length)
        height = try values.decodeIfPresent(Double.self, forKey: .height)
    }
}
