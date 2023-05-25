
import Foundation

struct BTTokenResponse : Codable {
	let transaction : BTToken?
}

struct BTToken : Codable {
    let clientToken : String?
}
