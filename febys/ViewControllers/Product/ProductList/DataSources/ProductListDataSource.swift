//
//  ProductListDataSource.swift
//  febys
//
//  Created by Waseem Nasir on 20/07/2021.
//

import UIKit

protocol ProductRepository {
    var pageNo: Int { get set }
    var pageSize: Int { get set }
    var filterParams: [String:[String:Any]]? { get set }
    var response: ((Result<ProductResponse, FebysError>)->())? { get set}
    
    func fetchProducts()
}

class TodayDealsRepository: NSObject, ProductRepository{

    var pageNo = 1
    var pageSize = 15
    
    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        var bodyParams: [String:Any] = [:]
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
                
        Loader.show()
        ProductService.shared.todayDeals(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class AllProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15
    var searchStr = ""
    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ searchStr: String) {
        super.init()
        self.searchStr = searchStr
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        let defaultKey = ParameterKeys.variants_default
        let attributeKey = ParameterKeys.variants_attributes_value
        
        if let _ = filterParams?[ParameterKeys.filters]?[attributeKey] {
            filterParams?[ParameterKeys.filters]?[defaultKey] = nil
        } else {
            filterParams?[ParameterKeys.filters]?[defaultKey] = true
        }
        
        var bodyParams: [String:Any] = [:]
        bodyParams[ParameterKeys.searchStr] = searchStr
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
        
        Loader.show()
        ProductService.shared.allProducts(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class TrendingProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo:pageNo] as [String : Any]
        
        let trendsOnSale = [ParameterKeys.variants_trendsOnSale: true]
        let statsValue = [ParameterKeys.variants_statsSales_value: ParameterKeys.desc]

        let bodyParams = [ParameterKeys.filters: trendsOnSale,
                          ParameterKeys.sorter: statsValue] as [String : Any]
        
        Loader.show()
        ProductService.shared.allProducts(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class Under100ProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        var bodyParams: [String:Any] = [:]
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
    
        Loader.show()
        ProductService.shared.under100(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class SameDayRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        let sameDayDelivery = [ParameterKeys.same_day_delivery: true]
        let bodyParams = [ParameterKeys.filters: sameDayDelivery] as [String:Any]
        
//        var bodyParams: [String:Any] = [:]
//        if let filters = filterParams?[ParameterKeys.filters] {
//             bodyParams[ParameterKeys.filters] = filters
//        }
//        if let sorter = filterParams?[ParameterKeys.sorter] {
//            bodyParams[ParameterKeys.sorter] = sorter
//        }
    
        Loader.show()
        ProductService.shared.editorsPick(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
    
}

class EditorsPickRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        let editorsPick = [ParameterKeys.editor_picked: true]
        let bodyParams = [ParameterKeys.filters: editorsPick] as [String : Any]
        
//        var bodyParams: [String:Any] = [:]
//        if let filters = filterParams?[ParameterKeys.filters] {
//             bodyParams[ParameterKeys.filters] = filters
//        }
//        if let sorter = filterParams?[ParameterKeys.sorter] {
//            bodyParams[ParameterKeys.sorter] = sorter
//        }
    
        Loader.show()
        ProductService.shared.editorsPick(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
    
}

class StoresYouFollowRepository: NSObject, ProductRepository{

    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        var bodyParams: [String:Any] = [:]
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
    
        Loader.show()
        ProductService.shared.storesYouFollow(params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class SimilarProductsRepository: NSObject, ProductRepository{
    var pageNo = 1
    var pageSize = 15
    var productId = ""

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ productId: String) {
        super.init()
        self.productId = productId
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize:pageSize, ParameterKeys.pageNo:pageNo] as [String : Any]
        
        Loader.show()
        ProductService.shared.similarProducts(id: productId, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class RecommendedProductsRepository: NSObject, ProductRepository{
    var pageNo = 1
    var pageSize = 15

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize:pageSize, ParameterKeys.pageNo:pageNo] as [String : Any]
        
        Loader.show()
        ProductService.shared.recommendedProducts(params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}


class CategoryProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15
    var categoryId = 0

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ categoryId: Int) {
        super.init()
        self.categoryId = categoryId
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        let defaultKey = ParameterKeys.variants_default
        let attributeKey = ParameterKeys.variants_attributes_value
        let filterKey = ParameterKeys.filters

        
        if let _ = filterParams?[filterKey]?[attributeKey] {
            filterParams?[filterKey]?[defaultKey] = nil
        } else {
            filterParams?[filterKey]?[defaultKey] = true
        }
//
        var bodyParams: [String:Any] = [:]
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
        
        Loader.show()
        CategoryService.shared.productListWithCategory(categoryId: categoryId, body: bodyParams, params: params){ response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class WishlistProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15
    var categoryId = 0

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ categoryId: Int) {
        super.init()
        self.categoryId = categoryId
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo:pageNo]
        
        Loader.show()
        WishListService.shared.getWishList(params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}


class VendorProductsRepository: NSObject, ProductRepository{
    
    var pageNo = 1
    var pageSize = 15
    var vendorId = ""

    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ vendorId: String) {
        super.init()
        self.vendorId = vendorId
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        
        let defaultKey = ParameterKeys.variants_default
        let attributeKey = ParameterKeys.variants_attributes_value
        let filterKey = ParameterKeys.filters
        
        if let _ = filterParams?[filterKey]?[attributeKey] {
            filterParams?[filterKey]?[defaultKey] = nil
        } else {
            filterParams?[filterKey]?[defaultKey] = true
        }

        var bodyParams: [String:Any] = [:]
        if let filters = filterParams?[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filters
        }
        if let sorter = filterParams?[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
        
        Loader.show()
        VendorService.shared.getVendorProductsBy(id: vendorId, body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class DiscountedProductsRepository: NSObject, ProductRepository{
    var pageNo = 1
    var pageSize = 15
    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    override init() {
        super.init()
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo:pageNo]
        let promotion = [ParameterKeys.variants_has_promotion: true]
        let bodyParams = [ParameterKeys.filters: promotion]

        Loader.show()
        ProductService.shared.allProducts(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

class SpecialStorsRepository: NSObject, ProductRepository{
    var pageNo = 1
    var pageSize = 15
    var storeFilter: SpecialFilter?
    var filterParams: [String:[String:Any]]?
    var response: ((Result<ProductResponse, FebysError>)->())?
    
    init(_ storeFilter: SpecialFilter) {
        super.init()
        self.storeFilter = storeFilter
        fetchProducts()
    }
    
    func fetchProducts() {
        let params = [ParameterKeys.chunkSize:pageSize, ParameterKeys.pageNo:pageNo] as [String : Any]
        
        let spacialType = [ParameterKeys.dollarIN: [storeFilter?.rawValue ?? ""]]
        let filter = [ParameterKeys.spacial_types: spacialType]
        let bodyParams = [ParameterKeys.filters: filter]
        
        print(bodyParams)
        
        Loader.show()
        ProductService.shared.specialStoreProducts(body: bodyParams, params: params) { response in
            Loader.dismiss()
            self.response?(response)
        }
    }
}

