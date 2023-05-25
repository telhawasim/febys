
import Foundation
struct Stats : Codable {
    let products : Int?
    let unitsSold : Int?
    let sales : Sales?
    let cancelledOrders : Int?
    let usedCount : Int?
    let rating : Score?

    enum CodingKeys: String, CodingKey {
        case unitsSold = "units_sold"
        case sales = "sales"
        case products = "products"
        case cancelledOrders = "cancelled_orders"
        case usedCount = "used_count"
        case rating = "rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent(Int.self, forKey: .products)
        unitsSold = try values.decodeIfPresent(Int.self, forKey: .unitsSold)
        sales = try values.decodeIfPresent(Sales.self, forKey: .sales)
        cancelledOrders = try values.decodeIfPresent(Int.self, forKey: .cancelledOrders)
        usedCount = try values.decodeIfPresent(Int.self, forKey: .usedCount)
        rating = try values.decodeIfPresent(Score.self, forKey: .rating)
    }
}

