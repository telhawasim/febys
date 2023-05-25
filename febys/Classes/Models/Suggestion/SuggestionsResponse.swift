
import Foundation

struct SuggestionsResponse : Codable {
    var listing : SuggestionsListing?

	enum CodingKeys: String, CodingKey {
		case listing = "listing"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		listing = try values.decodeIfPresent(SuggestionsListing.self, forKey: .listing)
	}

}
