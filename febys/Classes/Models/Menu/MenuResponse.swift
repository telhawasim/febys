import Foundation

struct MenuResponse : Codable {
	let id : String?
	let topMenu : [TopMenu]?
	let navigationMenu : [NavigationMenu]?
	let hamburgerMenu : [HamburgerMenu]?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case topMenu = "topMenu"
		case navigationMenu = "navigationMenu"
		case hamburgerMenu = "hamburgerMenu"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		topMenu = try values.decodeIfPresent([TopMenu].self, forKey: .topMenu)
		navigationMenu = try values.decodeIfPresent([NavigationMenu].self, forKey: .navigationMenu)
		hamburgerMenu = try values.decodeIfPresent([HamburgerMenu].self, forKey: .hamburgerMenu)
	}

}
