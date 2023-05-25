import Foundation

struct CartInfo : Codable {
	let id : Int?
	let orderAmount : Int?
	let vendors : [Vendor]?
}
