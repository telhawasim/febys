import Foundation

struct ReasonsResponse : Codable {
	let consumerReasons : Reason?
    let setting : Reason?

    enum CodingKeys: String, CodingKey {
        case consumerReasons = "consumerReasons"
        case setting = "setting"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        consumerReasons = try values.decodeIfPresent(Reason.self, forKey: .consumerReasons)
        setting = try values.decodeIfPresent(Reason.self, forKey: .setting)
    }
}
