import Foundation

class Vendor : Codable {
    let id : String?
    let email : String?
    let role : Role?
    let stats : Stats?
    let businessInfo : BusinessInfo?
    let contactDetails : ContactDetails?
    let name : String?
    let official : Bool?
    let shopName : String?
    let socials : [Social]?
    let template : [Template]?
    let templatePhoto : String?
    let active : Bool?
    let createdAt : String?
    let templatePublished : Bool?
    var ratingsAndReviews : [RatingsAndReviews]?
    let valueScore : [Score]?
    let pricingScore : [Score]?
    let qualityScore : [Score]?

    enum CodingKeys: String, CodingKey {

        case role = "role"
        case stats = "stats"
        case id = "_id"
        case email = "email"
        case businessInfo = "business_info"
        case contactDetails = "contact_details"
        case name = "name"
        case official = "official"
        case shopName = "shop_name"
        case socials = "socials"
        case template = "template"
        case templatePhoto = "template_photo"
        case active = "active"
        case createdAt = "created_at"
        case ratingsAndReviews = "ratings_and_reviews"
        case templatePublished = "template_published"
        case valueScore = "value_score"
        case pricingScore = "pricing_score"
        case qualityScore = "quality_score"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        role = try values.decodeIfPresent(Role.self, forKey: .role)
        stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        businessInfo = try values.decodeIfPresent(BusinessInfo.self, forKey: .businessInfo)
        contactDetails = try values.decodeIfPresent(ContactDetails.self, forKey: .contactDetails)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        official = try values.decodeIfPresent(Bool.self, forKey: .official)
        shopName = try values.decodeIfPresent(String.self, forKey: .shopName)
        socials = try values.decodeIfPresent([Social].self, forKey: .socials)
        template = try values.decodeIfPresent([Template].self, forKey: .template)
        templatePhoto = try values.decodeIfPresent(String.self, forKey: .templatePhoto)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        ratingsAndReviews = try values.decodeIfPresent([RatingsAndReviews].self, forKey: .ratingsAndReviews)
        templatePublished = try values.decodeIfPresent(Bool.self, forKey: .templatePublished)
        valueScore = try values.decodeIfPresent([Score].self, forKey: .valueScore)
        pricingScore = try values.decodeIfPresent([Score].self, forKey: .pricingScore)
        qualityScore = try values.decodeIfPresent([Score].self, forKey: .qualityScore)
    }
    
    func byMostRecent() {
        self.ratingsAndReviews?.sort(by: { ($0.createdAt ?? "") > ($1.createdAt ?? "") })
    }

}

struct Role : Codable {
    let id : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct BusinessInfo : Codable {
    let logo : String?
    let address : String?
    let location : Location?
    let vendorType : String?

    enum CodingKeys: String, CodingKey {

        case logo = "logo"
        case address = "address"
        case location = "location"
        case vendorType = "vendor_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        vendorType = try values.decodeIfPresent(String.self, forKey: .vendorType)
    }

}

struct ContactDetails : Codable {
    let email : String?
    let name : String?
    let phoneNumber : PhoneNumbers?
    let address : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case name = "name"
        case phoneNumber = "phone_number"
        case address = "address"
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phoneNumber = try values.decodeIfPresent(PhoneNumbers.self, forKey: .phoneNumber)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

struct Location : Codable {
    let type : String?
    let coordinates : [Double]?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case coordinates = "coordinates"
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        coordinates = try values.decodeIfPresent([Double].self, forKey: .coordinates)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

class PhoneNumbers : Codable {
    let countryCode : String?
    let number : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case countryCode = "country_code"
        case number = "number"
        case id = "_id"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        number = try values.decodeIfPresent(String.self, forKey: .number)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}
