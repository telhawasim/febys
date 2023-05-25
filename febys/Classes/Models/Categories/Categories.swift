//
//  UniqueCategory.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import Foundation
struct Categories : Codable {
	let id : Int?
	let parent_id : Int?
	let name : String?
	let slug : String?
	let icon : String?
	let logo : String?
    let commission_type : String?
    let commission : String?
    let deleted : Int?
	let enabled : Int?
	let featured : Int?
	let created_at : String?
	let updated_at : String?
    let created_by : String?
    let updated_by : String?
	let child_id : String?
	let child_name : String?
	let total_child : Int?
    let chain_id : String?
    let templates : [CategoryTemplate]?
	let children : [Categories]?
}
