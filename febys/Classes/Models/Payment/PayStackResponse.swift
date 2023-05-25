import Foundation

struct PayStackResponse : Codable {
    let transactionRequest : TransactionRequest?
    
    enum CodingKeys: String, CodingKey {
        case transactionRequest = "transaction_request"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionRequest = try values.decodeIfPresent(TransactionRequest.self, forKey: .transactionRequest)
    }
}

struct TransactionRequest : Codable {
	let authorization_url : String?
	let access_code : String?
	let reference : String?
}
