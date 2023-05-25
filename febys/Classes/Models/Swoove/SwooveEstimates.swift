
import Foundation

//MARK: SwooveEstimates
struct SwooveEstimates : Codable {
	let success : Bool?
	let code : Int?
	let message : String?
	var responses : SwooveResponse?

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case code = "code"
		case message = "message"
		case responses = "responses"
	}
}

//MARK: SwooveResponse
struct SwooveResponse : Codable {
    var selectedEstimate: Estimate?
    let optimalEstimate : Estimate?
    let paymentChannel : String?
    let estimates : [Estimate]?

    enum CodingKeys: String, CodingKey {
        case selectedEstimate = "selected_estimate"
        case optimalEstimate = "optimal_estimate"
        case paymentChannel = "payment_channel"
        case estimates = "estimates"
    }

}

//MARK: Estimate
struct Estimate : Codable {
    let customStartDate : String?
    let totalPricing : PriceDetail?
    let individualPricing : [IndividualPricing]?
    let deliveryTypeMessage : String?
    let isAggregated : Bool?
    let totalDistance : Double?
    let timeString : String?
    let instructions : String?
    let estimateId : String?
    let estimateTypeDetails : EstimateTypeDetail?

    enum CodingKeys: String, CodingKey {

        case customStartDate = "custom_start_date"
        case totalPricing = "total_pricing"
        case individualPricing = "individual_pricing"
        case deliveryTypeMessage = "delivery_type_message"
        case isAggregated = "is_aggregated"
        case totalDistance = "total_distance"
        case timeString = "time_string"
        case instructions = "instructions"
        case estimateId = "estimate_id"
        case estimateTypeDetails = "estimate_type_details"
    }

}

//MARK: EstimateTypeDetail
struct EstimateTypeDetail : Codable {
    let name : String?
    let icon : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case icon = "icon"
    }
}

//MARK: PriceDetail
struct PriceDetail : Codable {
    let discount : Double?
    let value : Double?
    let currencyCode : String?
    let currencySymbol : String?
    let currencyName : String?

    enum CodingKeys: String, CodingKey {

        case discount = "discount"
        case value = "value"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case currencyName = "currency_name"
    }
}

//MARK: IndividualPricing
struct IndividualPricing : Codable {
    let pickup : PointDetail?
    let dropoff : PointDetail?
    let contact : Contact?
    let items : [SwooveItem]?
    let priceDetails : PriceDetail?
    let timeString : String?
    let startTime : Int?
    let endTime : Int?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case pickup = "pickup"
        case dropoff = "dropoff"
        case contact = "contact"
        case items = "items"
        case priceDetails = "price_details"
        case timeString = "time_string"
        case startTime = "start_time"
        case endTime = "end_time"
        case id = "_id"
    }

}

//MARK: PointDetail
struct PointDetail : Codable {
    let lat : Double?
    let lng : Double?
    let countryCode : String?
    let value : String?
    let type : String?
    let location : String?
    let contact : Contact?
    let serviceZoneId : String?
    let aggregationCenterId : String?

    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lng = "lng"
        case countryCode = "country_code"
        case value = "value"
        case type = "type"
        case location = "location"
        case contact = "contact"
        case serviceZoneId = "service_zone_id"
        case aggregationCenterId = "aggregation_center_id"
    }

}

//MARK: Contact
struct Contact : Codable {
    let name : String?
    let email : String?
    let mobile : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case email = "email"
        case mobile = "mobile"
    }

}

//MARK: SwooveEstimates
struct SwooveItem : Codable {
    let itemName : String?
    let itemIcon : String?
    let itemQuantity : Int?
    let itemCost : Double?
    let itemPrice : String?
    let currencyCode : String?
    let currencySymbol : String?
    let currencyName : String?
    let collectCash : Bool?
    let description : String?
    let itemWeight : Double?
    let dimensions : Dimensions?
    let categoryId : String?
    let itemImage : String?

    enum CodingKeys: String, CodingKey {

        case itemName = "itemName"
        case itemIcon = "itemIcon"
        case itemQuantity = "itemQuantity"
        case itemCost = "itemCost"
        case itemPrice = "itemPrice"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case currencyName = "currency_name"
        case collectCash = "collect_cash"
        case description = "description"
        case itemWeight = "itemWeight"
        case dimensions = "dimensions"
        case categoryId = "category_id"
        case itemImage = "itemImage"
    }

}


//MARK: Dimensions
struct Dimensions : Codable {
    let sizeId : String?
    let x : Double?
    let y : Double?
    let z : Double?

    enum CodingKeys: String, CodingKey {

        case sizeId = "size_id"
        case x = "x"
        case y = "y"
        case z = "z"
    }
}
