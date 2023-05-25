import Foundation

struct Warranty : Codable {
    let id : String?
    let applicable : Bool?
    let durationDays : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case applicable = "applicable"
        case durationDays = "duration_days"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        applicable = try values.decodeIfPresent(Bool.self, forKey: .applicable)
        durationDays = try values.decodeIfPresent(Int.self, forKey: .durationDays)
    }
    
}
