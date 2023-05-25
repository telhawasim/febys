
import Foundation
import PayPalCheckout

struct Price : Codable {
    var id : String?
    var key : String?
    var value : Double?
    var currency : String?
    var ranges : [Ranges]?
    
    var purchaseType: PurchaseType?
    var isSplitAmountDeducted = false
    var amountToDeductForSplit = 0.0
    var amountAfterDeductionForSplit = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case key = "key"
        case value = "value"
        case currency = "currency"
        case ranges = "ranges"
    }

    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        value = try values.decodeIfPresent(Double.self, forKey: .value)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        ranges = try values.decodeIfPresent([Ranges].self, forKey: .ranges)
    }

    var getPayPalCurrenyIfSupported: CurrencyCode?{
        var currencyCode = CurrencyCode.usd
        
        switch self.currency {
        case "USD":
            currencyCode = .usd
        case "AUD":
            currencyCode = .aud
        case "EUR":
            currencyCode = .eur
        case "CAD":
            currencyCode = .cad
        case "MXN":
            currencyCode = .mxn
        case "GBP":
            currencyCode = .gbp
        default:
            return nil
        }
        
        return currencyCode
    }
      
    func formattedPrice() -> String? {
        let currency = getCurrencySymbolBy(code: self.currency ?? "GHS")
        let amount = self.value?.round(to: 2)
        return "\(currency ?? "$") \(amount?.formatNumber() ?? "0.0")"
    }
    
    func getCurrencySymbolBy(code: String) -> String? {
//        if code == "GHS" {
//            return "GH₵"
//        } else {
            let locale = NSLocale(localeIdentifier: code)
            return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
//        }
    }
    
    func convertAmount(to: String, completion: @escaping ((Double) -> Void)) {
        self.currencyConversion(from: currency ?? "", to: to) { rate in
            let amount = (self.value ?? 0.0) * (rate ?? 0.0)
            completion(amount.round(to: 2))
        }
    }
    
    
    func currencyConversion(from: String, to: String, onComplete: @escaping (Double?) -> ()) {
        
        let bodyParams = [ParameterKeys.from: from.uppercased(),
                          ParameterKeys.to: to.uppercased()]

        Loader.show()
        PriceService.shared.getConversionRate(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let rate):
                onComplete(rate.conversion_rate)
                break
            case .failure(_):
                break
            }
        }
    }
    
}
