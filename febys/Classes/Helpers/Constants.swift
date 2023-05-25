//
//  Constants.swift
//  febys
//
//  Created by Waseem Nasir on 25/06/2021.
//

import UIKit

class Constants: NSObject {
    private override init() { }
    
    static let authorization = "Authorization"
    static let user = "user"
    static let userInfo = "userInfo"
    static let shippingDetails = "shippingDetails"
    static let updateCart = "updateCart"
    static let Error = "Error"
    static let Sorry = "Sorry"
    static let unAuthorized = "Invalid credentials"
    static let Shipping = "Shipping Address"
    static let kFirebaseToken = "kFirebaseToken"
    
    //MARK: KEYCLOCK
    static let febys_backend = "febys-backend"
    static let refresh_token = "refresh_token"
    
    //MARK: SIGNUP SIGNIN
    static let SomethingWentWrong = "Something went wrong"
    static let IsRequired = "is required"
    static let Email = "Email"
    static let EnterEmail = "Enter Email"
    static let Password = "Password"
    static let ConfirmPassword = "Re-Enter Password"
    static let PasswordNotMatch = "Password and Confirm Password does not match"
    static let IsInvalid = "is invalid"
    static let FirstName = "First Name"
    static let LastName = "Last Name"
    static let PhoneNumber = "Phone Number"
    static let Message = "Message"
    static let Comment = "Comment"
    static let emailSent = "Email sent"
    static let VoucherCode = "Voucher Code"
    static let passwordLimit = "must be atleast 8 characters"
    static let areYouSure = "Are You Sure?"
    static let thankYou = "Thank You"
    static let profileUpdatedSuccessfully = "Your profile has been updated successfully."
    static let reviewAddedSuccessfully = "Your review has been added successfully."
    static let reviewUpdatedSuccessfully = "Your review has been updated successfully."
    
    static let youWantToDeleteUser = "You want to delete your accout. All your data will be removed."
    static let youWantToRemove = "You want to remove this item from bag."
    static let youWantToDelete = "You want to delete the shipping address."
    static let youWantToRemoveVoucher = "You want to remove voucher."
    static let youWantToUnfollowVendor = "You want to unfollow this Vendor."
    static let youWantToUnfollowCelebrity = "You want to unfollow this Celebrity."
    static let shippingAddressChange = "If you change the shipping address that will be effected on shipping cost."
    
    static let congratulation = "Congrats!"
    static let youWantToDownloadPDF = "You want to download the PDF."
    static let pdfDownloadSuccess = "PDF downloaded successfully. You can view the PDF in Files under Febys Directory."
    static let orderAmountZero = "The Order amount cannot be Zero."
    static let voucherAmountNotMinimum = "You haven't reached the minimum order value to use this voucher. Please add more items to cart."

    static let notificationTitleMinimumSize: CGFloat = 32.0
    static let ios = "ios"
    
    //MARK: ADDRESS
    static let addressLabel = "Address Label"
    static let destinationRegion = "Destination/Region"
    static let address = "Address"
    static let city = "City"
    static let state = "State"
    static let postalCode = "Postal Code"
    static let addAddress = "Please add a shipping address."
    static let selectAddress = "Please Add or Select a shipping address."
    static let selectEstimate = "We are unable to proceed your request. Please select a shipping method."
    static let selectAddressForEstimate = "We are unable to proceed your request. Please provide a shipping address."
    static let estimateError = "Sorry It seems that we are not delivering in your area. We are planing to expand our service in your area soon."


    
    //MARK: Product Detail
    static let description = "Description"
    static let manufacturer = "Manufacturer"
    static let reviews = "Reviews"
    static let qNa = "Q&As"
    static let shippingFeeAndRetuns = "Shipping Fee & Retuns"
    
    //MARK: Account
    static let myOrders = "My Orders"
    static let orderReceived = "Received Orders"
    static let myReview = "My Reviews"
    static let cancelOrders = "Cancelled Orders"
    static let returnOrders = "Returned Orders"
    static let wishlist = "Wishlist"
    static let userCountry = "Ghana"
    
    static let notifications = "Notifications"
    static let accountSettings = "Account Settings"
    static let vouchers = "Vouchers"
    static let shippingAddress = "Shipping Address"
    static let shippingMethod = "Shipping Method"

    static let aboutFebys = "About Febys"
    static let helpCenter =  "Help Center"
    static let privacyPolicy = "Privacy Policy"
    static let termsAndConditions = "Terms & Conditions"
    
    static let ordersSection = "Orders"
    static let myLocationSection = "My Location"
    static let settingsSection = "Settings"
    static let supportSection = "Support"
    
    //MARK: SearchTab
    static let categories = "Categories"
    static let stores = "Stores"
    static let vendorStores = "Vendor Stores"
    static let celebrityMarket = "Celebrity Market"
    static let promotion = "Promotion"
    static let filterBy = "Filter By"

    //MARK: VendorsListing
    static let storesYouFollowSection = "Stores You Follow"
    static let exploreStoresSection = "Explore Stores"
    
    //MARK: Vendors Store Social Links
    static let linkedIn = "LinkedIn"
    static let facebook = "Facebook"
    static let instagram = "Instagram"
    static let youtube = "Youtube"
    static let pinterest = "Pinterest"
    static let twitter = "Twitter"

    //MARK: CelebrityListing
    static let marketsYouFollowSection = "Celebrities You Follow"
    static let exploreMarketsSection = "Explore Markets"
    
    //MARK: Order
    static let SUBSCRIPTION_PURCHASED = "SUBSCRIPTION_PURCHASED"
    static let PRODUCT_PURCHASE = "PRODUCT_PURCHASE"
    static let pending = "Pending"
    static let returned = "Returned"
    static let toReview = "To Review"
    static let publishedReviews = "Published Reviews"
    
    //MARK: Voting
    static let PRODUCT_ID = "PRODUCT_ID"
    static let THREAD_ID = "THREAD_ID"
    static let ORDER_ID = "ORDER_ID"
    static let VENDOR_ID = "VENDOR_ID"
    static let REVIEW_ID = "REVIEW_ID"
    static let VOUCHER_CODE = "VOUCHER_CODE"
    static let NOTIFICATION_ID = "NOTIFICATION_ID"
    static let TEMPLATE_ID = "TEMPLATE_ID"
    static let PAYSTACK_TRANSACTION_ID = "PAYSTACK_TRANSACTION_ID"
    static let PACKAGE_ID = "PACKAGE_ID"
    static let REFUND = "REFUND"

    //MARK: Questions
    static let askAboutQuestion = "Ask about the product."
    static let replyToQuestion = "Reply to the question."
    static let questions = "Questions:"
    static let question = "Question"
    static let answer = "Answer"
    static let reply = "Reply:"
    
    //MARK: Date&Time
    static let UTCFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    static let dateFormatDD_MMM_yyyy = "dd-MMM-yyyy"
    static let dateFormatMMMMddyyyy = "MMMM dd, yyyy"
    static let dateFormatMMMddyyyy = "MMM dd, yyyy"
    static let timeFormatHHmmA = "hh:mm a"
    
    //MARK: Empty Views
    static let EmptyScreenTitle = "Oops!"
    static let EmptyScreenDescription = "No Orders Found"
    static let EmptyScreenVendorsDescription = "No Vendors Found"
    static let EmptyScreenShippingAdressDescription = "No Shipping Address Found"
    static let EmptyScreenVouchersDescription = "No Voucher Found"
    static let EmptyScreenHistoryDescription = "No History Found"
    static let EmptyScreenCategoriesDescription = "No Categories Found"
    static let EmptyScreenStoresDescription = "No Stores Found"
    static let EmptyScreenQuestionsDescription = "No Question And Answer Found"
    static let EmptyScreenWishListDescription = "No Wishlist Item Found"
    static let EmptyScreenProductsDescription = "No Products Found"
    static let EmptyScreenNotificationDescription = "No Notifications Found"

    //MARK: Menu List
    static let FebysPlus = "Febys Plus"
    static let DiscountMall = "Discount Mall"
    static let PawnShop = "Pawn Shop"
    static let MadeInGhana = "Made in Ghana"
    static let AfricanMarket = "African Market"
    static let ThriftMarket = "Thrift Market"
    
    //MARK: Vendor Constants
    static let CelebrityInfluencer = "Celebrity/Influencer"
    static let IndividualVendor = "Individual Vendor"
    static let ProfessionalVendor = "Professional Vendor"
    static let SuperAdmin = "Super admin"
    
    //MARK: Payments
    static let amountShouldBeGreater = " equivalent for the selected amount should be greater than zero, please select bigger amount!"
    
}

struct ParameterKeys {
    private init() { }
    
    static let uuid = "uuid"
    
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
    static let phone_number = "phone_number"
    static let country_code = "country_code"
    static let password = "password"
    static let profile_image = "profile_image"
    static let otp = "otp"
    static let notificationsStatus = "notificationsStatus"

    
    static let access_token = "access_token"
    static let type = "type"
    static let client = "client"
    static let client_id = "client_id"
    static let grant_type = "grant_type"
    static let refresh_token = "refresh_token"
    static let client_secret = "client_secret"
    
    static let chunkSize = "chunkSize"
    static let pageNo = "pageNo"
    static let queryStr = "queryStr"
    static let orderByCol = "orderByCol"
    static let orderByType = "orderByType"
    
    static let start_date = "start_date"
    static let end_date = "end_date"
    
    static let product_variant_ids = "product_variant_ids"
    static let order_id = "order_id"
    static let sku_ids = "sku_ids"
    static let sku_id = "sku_id"
    static let score = "score"
    static let review = "review"
    static let comment = "comment"

    static let label = "label"
    static let address = "address"
    static let coordinates = "coordinates"
    static let location = "location"
    static let zip_code = "zip_code"
    static let state = "state"
    static let city = "city"
    static let street = "street"
    static let contact = "contact"
    static let number = "number"
    static let _default = "default"
    static let id = "_id"
    static let shipping_detail = "shipping_detail"
    static let items = "items"
    static let voucherCode = "voucher_code"
    static let messages = "messages"
    static let swoove = "swoove"
    static let estimate = "estimate"

    static let message = "message"
    static let amount = "amount"
    static let currency = "currency"
    static let purpose = "purpose"
    static let transactionFee = "transactionFee"
    static let billingAmount = "billingAmount"
    static let billingCurrency = "billingCurrency"
    static let transaction_ids = "transaction_ids"
    static let state_code = "state_code"
    
    
    static let dollarIN =  "$in"
    static let dollarNE =  "$ne"
    static let filters = "filters"
    static let sorter = "sorter"
    static let searchStr = "searchStr"
    static let created_at = "created_at"
    static let desc = "desc"
    static let status1 = "status"
    static let products_status = "vendor_products.status"
    static let products_return_status = "vendor_products.returns_detail.status"
    static let has_reviewed = "vendor_products.hasReviewed"

    static let reason = "reason"
    static let comments = "comments"

    static let title = "title"
    static let vendor_id = "vendor_id"
    static let pricing_score = "pricing_score"
    static let value_score = "value_score"
    static let quality_score = "quality_score"
    static let vendor_rating = "vendor_rating"
    static let products_ratings = "products_ratings"
    static let return_items = "return_items"
    static let qty = "qty"

    static let minimum = "minimum"
    static let maximum = "maximum"

    static let spacial_types = "spacial_types"
    static let variants_default = "variants.default"
    static let category_id = "category_id"
    static let variants_attributes_value = "variants.attributes.value"
    static let variants_price_value = "variants.price.value"
    static let variants_has_promotion = "variants.has_promotion"
    static let variants_trendsOnSale = "variants.trendsOnSale"
    static let variants_statsSales_value = "variants.stats.sales.value"
    static let editor_picked = "editor_picked"
    static let same_day_delivery = "sameDayDelivery"
    static let featured = "featured"
    static let dollarOR = "$or"
    static let greaterThen = "$gte"
    static let lessThen = "$lte"

    static let from = "from"
    static let to = "to"
    
}


struct Defaults {
    private init() { }
    
    static let currency = "USD"
    static let double = 0.00

}
