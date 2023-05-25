
import Foundation

struct APIError : Codable {
	let status : Int?
	let message : String?
	let errors : [Errors]?
}
