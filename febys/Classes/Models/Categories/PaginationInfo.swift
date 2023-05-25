//
//  UniqueCategory.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import Foundation
struct PaginationInfo : Codable {
	let pageNo : Int?
	let totalPages : Int?
	let startRecord : Int?
	let endRecord : Int?
	let totalRows : Int?

	enum CodingKeys: String, CodingKey {
		case pageNo = "page_no"
		case totalPages = "total_Pages"
		case startRecord = "start_record"
		case endRecord = "end_record"
		case totalRows = "total_rows"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
		totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
		startRecord = try values.decodeIfPresent(Int.self, forKey: .startRecord)
		endRecord = try values.decodeIfPresent(Int.self, forKey: .endRecord)
		totalRows = try values.decodeIfPresent(Int.self, forKey: .totalRows)
	}

}
