
import Foundation

struct Refund : Codable {
    let id : String?
    let refundable : Bool?
    let policy : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case refundable = "refundable"
        case policy = "policy"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        refundable = try values.decodeIfPresent(Bool.self, forKey: .refundable)
        policy = try values.decodeIfPresent(String.self, forKey: .policy)
    }

}
