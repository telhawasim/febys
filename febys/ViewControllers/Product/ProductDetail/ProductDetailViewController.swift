//
//  ProductDetailViewController.swift
//  febys
//
//  Created by Waseem Nasir on 13/07/2021.
//

import UIKit
import WebKit
import Cosmos
import ImageViewer

struct CollapsingData {
    let isExpanded: Bool?
    let title: String?
    let contentView: UIView?
}

class ProductDetailViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var favouriteIcon: FebysButton!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var outOfStockLabel: FebysLabel!
    @IBOutlet weak var brandNameLabel: FebysLabel!
    @IBOutlet weak var productNameLabel: FebysLabel!
    @IBOutlet weak var productPriceLabel: FebysLabel!
    @IBOutlet weak var orgionalPriceLabel: FebysLabel!
    @IBOutlet weak var savedPriceLabel: FebysLabel!
    @IBOutlet weak var originalPriceStackView: UIStackView!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet weak var dashLabel: FebysLabel!
    @IBOutlet weak var readmoreLabel: FebysLabel!
    @IBOutlet weak var buywithExchangeLabel: FebysLabel!
    @IBOutlet weak var tAndCLabel: FebysLabel!
    
    @IBOutlet weak var collapsingStackView: UIStackView!
    @IBOutlet weak var variantButton: FebysButton!
    @IBOutlet weak var variantButton2: FebysButton!
    @IBOutlet weak var dropdownView1: UIView!
    @IBOutlet weak var dropdownView2: UIView!
    @IBOutlet weak var dropdownLabel1: FebysLabel!
    @IBOutlet weak var dropdownLabel2: FebysLabel!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var addToCartButton: FebysButton!
    @IBOutlet weak var payNowButton: FebysButton!
    @IBOutlet weak var recommendedProductsStackView: UIStackView!
    @IBOutlet weak var similarProductsStackView: UIStackView!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var recommendedCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopAllRecommendedButton: FebysButton!
    @IBOutlet weak var shopAllSimilarButton: FebysButton!

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeButton: FebysButton!
    @IBOutlet weak var storeName: FebysLabel!
    @IBOutlet weak var storeRole: FebysLabel!
    @IBOutlet weak var officialBadgeImage: UIImageView!
    @IBOutlet weak var storeRatingStar: CosmosView!
    @IBOutlet weak var storeAvarageRating: FebysLabel!
    @IBOutlet weak var addProtrctionView: UIView!
    
    //MARK: PROPERTIES
    private let numberOfItemPerRow = 1
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(0)
    private let minimumLineSpacing = CGFloat(0)
    
    var productDetail: Product?
    var productId: String = ""
    var threadId: String?
    var productImages: [String]?
    
    private var collapsingData: [CollapsingData] = []
    private var similarProductResponse: ProductResponse?
    private var recommendedProductResponse: ProductResponse?
    
    var preferredSkuId: String?
    var variantDictionary = [String: [String:Variant]]()
    var selectedFirstAttribute = [String:Variant]()
    var selectedVariant: Variant? {
        didSet {
            self.configureButtonUI(isEnable: selectedVariant?.availability ?? true)
        }
    }
    
    var counter = 0
    var timer = Timer()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
        registerCollectionViewCells()
        fetchProductDetail()
        fetchSimilarProducts()
        fetchRecommendedProducts()
        updateCartCount()
        setText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
    
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    //MARK: Setup Views
    func registerCollectionViewCells() {
        imagesCollectionView.register(ProductImagesCell.className)
        recommendedCollectionView.register(ProductItemCell.className)
        similarCollectionView.register(ProductItemCell.className)
    }
    
    @objc func slide(){
        if let count = productImages?.count,
           (self.imagesCollectionView.numberOfItems(inSection: 0) > 0) {
            if counter < count {
                let indexPath = IndexPath(item: counter, section: 0)
                self.imagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                counter += 1
            } else {
                counter = 0
                let indexPath = IndexPath(item: counter, section: 0)
                self.imagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                counter = 1
            }
        }
    }

    func setText(){
        let message1 = "Mobile Money Payments are accepted across all networks"
        let attributedString1 = NSMutableAttributedString(string: message1)
        readmoreLabel.attributedText = attributedString1
        
        let message2 = "Pay with your Bank cards or PayPal Account. We’ve got you covered"
        let attributedString2 = NSMutableAttributedString(string: message2)
        buywithExchangeLabel.attributedText = attributedString2
        
        let message3 = "Save and Pay for items with our Wallet feature"
        let attributedString3 = NSMutableAttributedString(string: message3)
        tAndCLabel.attributedText = attributedString3
        self.addProtrctionView.isHidden = true
    }
    
    //MARK: Button Actions
    func setButtons() {
        variantButton.didTap = { [weak self] in
            self?.presentPicker(first: true)
        }
        
        variantButton2.didTap = { [weak self] in
            self?.presentPicker(first: false)
        }
        
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
        
        addToCartButton.didTap = {[weak self] in
            guard let self = self else { return }
            if let variant = self.selectedVariant, let product = self.productDetail{
                CartEntity.updateCart(withProduct: variant, product: product, vendorId: product.vendorId)
        
                FebysSnackBar.make(in: self.scrollView, message: "Item has been added to the bag", duration: .lengthShort).setAction(with: "VIEW BAG", action: {
                    RedirectionManager.shared.showCart()
                }).show()

                self.updateCartCount()
            }
        }
        
        payNowButton.didTap = {[weak self] in
            if User.fetch() != nil {
                self?.fetchOrderDetail { orderInfo in
                    self?.goToCheckout(with: orderInfo)
                }
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
        
        shopAllRecommendedButton.didTap = {[weak self] in
            self?.goToProductList(title: "Recommended Products", filterType: .none, RecommendedProductsRepository())
        }
        
        shopAllSimilarButton.didTap = {[weak self] in
            self?.goToProductList(title: "Similar Products", filterType: .none, SimilarProductsRepository(self?.productId ?? ""))
        }
        
        storeButton.didTap = { [weak self] in
            if let id = self?.productDetail?.vendor?.id {
                self?.goToVendorDetail(of: id)
            }
        }
        
    }
    
    //MARK: Navigation
    func goToSignIn() {
        let vc = UIStoryboard.getVC(from: .Auth, SignInViewController.className) as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToQuestionAnswerListing(productId: String, threadId: String, threads: [QnAThread]) {
        let vc = UIStoryboard.getVC(from: .Product, QuestionsAnswersViewController.className) as! QuestionsAnswersViewController
        vc.productId = productId
        vc.threadId = threadId
        vc.qaThreads = threads
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductList(title: String, filterType: FilterType, _ repo: ProductRepository){
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.titleName = title
        vc.filterType = filterType
        vc.repo = repo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetail(_ productId: String, skuId: String){
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.preferredSkuId = skuId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCheckout(with orderInfo: OrderResponse?) {
        let vc = UIStoryboard.getVC(from: .ShoppingCart, CheckoutViewController.className) as! CheckoutViewController
        vc.orderInfo = orderInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Helpers
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)

    }
    
    func configureButtonUI(isEnable: Bool) {
        self.addToCartButton.isEnabled = isEnable ? true : false
        self.payNowButton.isEnabled = isEnable ? true : false
    }
    
    func didHideOutOfStock(_ isHidden: Bool) {
        self.outOfStockLabel.isHidden = isHidden
    }
    
    func didHidePromotionPrice(_ isHidden: Bool) {
        isHidden
        ? (self.orgionalPriceLabel.isHidden = true)
        : (self.orgionalPriceLabel.isHidden = false)
        self.dashLabel.isHidden = true
    }
    
    func setData() {
        let defaultVarient = productDetail?.variants?.first(where: {$0.isDefault == true})
        
        if let url = productDetail?.vendor?.businessInfo?.logo { storeImage.setImage(url: url) }
        else { storeImage.image = UIImage(named: "user.png") }
        
        
        guard let vendor = productDetail?.vendor else {return}
        storeName.text = vendor.shopName
        storeRole.text = vendor.role?.name
        storeRatingStar.rating = vendor.stats?.rating?.score ?? 5.0
        storeRatingStar.settings.fillMode = .precise
        storeAvarageRating.text = "(\(vendor.stats?.rating?.score ?? 5.0)) Ratings"
        titleLabel.text = vendor.shopName
        brandNameLabel.text = vendor.shopName
        productNameLabel.text = productDetail?.name
        productImages = defaultVarient?.images
        
        if let isOfficial =  vendor.official {
            self.officialBadgeImage.isHidden = isOfficial ? false : true
        }
        
        if let hasPromotion = defaultVarient?.hasPromotion {
            self.originalPriceStackView.isHidden = hasPromotion ? false : true
            self.savedPriceLabel.isHidden = hasPromotion ? false : true
        }
        
        if let inStock = defaultVarient?.availability {
            self.outOfStockLabel.isHidden = inStock
        }
        
        let savedAmount = getDifference(x: defaultVarient?.originalPrice?.value ?? 0.0, y: defaultVarient?.price?.value ?? 0.0)
        var savedPrice = Price()
        savedPrice.value = savedAmount
        savedPrice.currency = defaultVarient?.price?.currency
        
        pageControl.numberOfPages = productImages?.count ?? 0
        productPriceLabel.text = defaultVarient?.price?.formattedPrice()
        self.savedPriceLabel.text = "Save \(savedPrice.formattedPrice() ?? "0.0")"
        orgionalPriceLabel.text = defaultVarient?.originalPrice?.formattedPrice()
        orgionalPriceLabel.strikeThrough(true)
        
        

        self.imagesCollectionView.reloadData()
    }
    
    func getDifference(x: Double, y: Double) -> Double {
        return (x - y).round(to: 2)
    }
    
    func prepareVariants(){
        let varients = self.productDetail?.variants
        let firstVariant = varients?.first
        let defaultVariant = varients?.first(where: {$0.isDefault == true})
        let preferredVariant = varients?.first(where: {$0.skuId == preferredSkuId})
        let variant = preferredVariant ?? defaultVariant ?? firstVariant
        
        if variant?.attributes?.count ?? 0 <= 1{
            dropdownView2.isHidden = true
        }
        
        _ = productDetail?.variants?.compactMap({ variant in
            let attributes = variant.attributes
            
            if variantDictionary[attributes?.first?.value?.trim() ?? ""] == nil{
                variantDictionary[attributes?.first?.value?.trim() ?? ""] = [:]
            }
            
            if variantDictionary[attributes?.first?.value?.trim() ?? ""]?[attributes?.last?.value?.trim() ?? ""] == nil{
                variantDictionary[attributes?.first?.value?.trim() ?? ""]?[attributes?.last?.value?.trim() ?? ""] = variant
            }
        })
        
        if let key = variant?.attributes?.first?.name,
           let value = variant?.attributes?.first?.value?.trim(),
           let attribute = variantDictionary[value]{
            selectedFirstAttribute = attribute
            dropdownLabel1.text = "\(key): \(value)"
            
            if let key = variant?.attributes?.last?.name,
               let value = variant?.attributes?.last?.value?.trim(),
               let variant = attribute[value]{
                selectVariant(variant)
                dropdownLabel2.text = "\(key): \(value)"
            } else { selectVariant() }
        } else { selectVariant(variant) }
    }
    
    func selectVariant(_ variant: Variant? = nil){
        var variant = variant
        if variant == nil{
            let key = self.selectedFirstAttribute.keys.first ?? ""
            variant = self.selectedFirstAttribute[key]
        }
        
        selectedVariant = variant
        self.favouriteIcon.isSelected = WishlistManager.shared.isFavourite(variantId: selectedVariant?.skuId ?? "")
        
        self.favouriteIcon.didTap = { [weak self] in
            if let id = variant?.skuId{
                WishlistManager.shared.addORRemoveFromWishlist((self?.favouriteIcon)!, variantId: id)
            }
        }
        
        productImages = variant?.images
        productPriceLabel.text = variant?.price?.formattedPrice()
        orgionalPriceLabel.text = variant?.originalPrice?.formattedPrice()
        
        pageControl.numberOfPages = variant?.images?.count ?? 0
        self.imagesCollectionView.reloadData()
    }
    
    //MARK: PickerView
    func presentPicker(first: Bool){
        let vc = UIStoryboard.getVC(from: .Product, ProductVariantPickerViewController.className) as! ProductVariantPickerViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        let attributes = self.productDetail?.variants?.first?.attributes
        
        if first{
            vc.pickerData = variantDictionary.keys.sorted()
            vc.titleString = "Select \(attributes?.first?.name ?? "")"
            
            if let index = Array(variantDictionary.keys.sorted()).firstIndex(of: selectedFirstAttribute.values.first?.attributes?.first?.value){
                vc.selectedRow = index
            }
            
            vc.didSelectRow = { [weak self] row in
                if let item = self?.variantDictionary[row]{
                    self?.selectedFirstAttribute = item
                    self?.selectVariant()
                    self?.dropdownLabel1.text = "\(attributes?.first?.name ?? ""): \(row)"
                    self?.dropdownLabel2.text = "\(attributes?.last?.name ?? ""): \(self?.selectedFirstAttribute.keys.first ?? "")"
                }
            }
        }else{
            vc.pickerData = selectedFirstAttribute.keys.dropLast(0)
            vc.titleString = "Select \(attributes?.last?.name ?? "")"
            
            let secondValue =  dropdownLabel2.text?.components(separatedBy: ": ")[1]
            if let index = Array(selectedFirstAttribute.keys.sorted()).firstIndex(of: secondValue?.trim()){
                vc.selectedRow = index
            }
        
            
            vc.didSelectRow = { [weak self] row in
                if let item = self?.selectedFirstAttribute[row]{
                    self?.dropdownLabel2.text = "\(attributes?.last?.name ?? ""): \(row)"
                    self?.selectVariant(item)
                }
            }
        }
        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: CollapsingViews
    func prepareCollapsingData() {
        if let product = productDetail {
            _ = product.descriptions?.enumerated().compactMap(
                { (index, description) in
                    
                    let descriptionView: DescriptionViewCell = .fromNib()
                    descriptionView.configure(description)
                    collapsingData.append(
                        CollapsingData(isExpanded: (index == 0) ? true : false,
                                       title: description.title,
                                       contentView: descriptionView)
                    )
                }
            )
            
            let review: ReviewsViewCell = .fromNib()
            review.configure(product)
            collapsingData.append(
                CollapsingData(isExpanded: false,
                               title: "Reviews",
                               contentView: review)
            )
            
            let qna: QnAViewCell = .fromNib()
            qna.configure(product)
            collapsingData.append(
                CollapsingData(isExpanded: false,
                               title: "Q&As",
                               contentView: qna)
            )
            
            let shippingNReturns: ShippingAndReturnViewCell = .fromNib()
            shippingNReturns.configure(self.selectedVariant)
            
            shippingNReturns.returnNRefundPolicyButton.didTap = { [weak self] in
               guard let self = self else {return}
                self.showMessage(Constants.areYouSure, Constants.youWantToDownloadPDF, messageImage: .pdf, isQuestioning: true, onSuccess: {
                    if let urlString = self.selectedVariant?.refund?.policy {
                        let pdfUrl = URL(string: urlString)
                        let pdfData = try? Data.init(contentsOf: pdfUrl!)
                        self.saveRetunPolicyPDF(pdfData: pdfData!)
                    }
                }, onDismiss: nil)
            }
            
            collapsingData.append(
                CollapsingData(isExpanded: false,
                               title: "Shipping Fee & Returns",
                               contentView: shippingNReturns)
            )
        }
        self.loadCollapsingViews()
    }
    
    func collapsingView(_ stackView: UIStackView, with data: CollapsingData) {
        let collapseView: CollapsingView = .fromNib()
        collapseView.configure(data)
        stackView.addArrangedSubview(collapseView)
    }
    
    func loadCollapsingViews() {
        self.collapsingStackView.removeAllArrangedSubviews()
        for myView in  collapsingData {
            collapsingView(collapsingStackView, with: myView)
        }
    }
    
    func fetchOrderDetail(completion: @escaping (OrderResponse)->Void) {
        let item = [ParameterKeys.sku_id : selectedVariant?.skuId ?? "",
                    ParameterKeys.qty : 1 ] as [String : Any]
        
        let bodyParams = [ParameterKeys.items: [item]] as [String : Any]
        Loader.show()
        OrderService.shared.fetchOrderInfo(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let info):
                completion(info)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: API CALLS
    func fetchProductDetail(){
        Loader.show()
        ProductService.shared.productDetail(id: productId) { response in
            Loader.dismiss()
            switch response{
            case .success(let productDetail):
                self.productDetail = productDetail.product
                _ = self.productDetail?.questionAnswers?.reverse()
                self.setData()
                self.prepareVariants()
                self.prepareCollapsingData()
                
                if let id = self.threadId {
                    self.goToQuestionAnswerListing(productId: productDetail.product?.id ?? "", threadId: id, threads: productDetail.product?.questionAnswers ?? [])
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchSimilarProducts() {
        let params = [ParameterKeys.chunkSize: 4, ParameterKeys.pageNo: 1]
        Loader.show()
        ProductService.shared.similarProducts(id: self.productId, params: params) { response in
            Loader.dismiss()
            switch response{
            case .success(let productResponse):
                if (productResponse.listing?.products?.count ?? 0) > 0 {
                    self.similarProductsStackView.isHidden = false
                }
                self.similarProductResponse = productResponse
                self.similarCollectionView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchRecommendedProducts() {
        let params = [ParameterKeys.chunkSize: 4, ParameterKeys.pageNo: 1]
        Loader.show()
        ProductService.shared.recommendedProducts(params: params) { response in
            Loader.dismiss()
            switch response{
            case .success(let productResponse):
                if (productResponse.listing?.products?.count ?? 0) > 0 {
                    self.recommendedProductsStackView.isHidden = false
                }
                self.recommendedProductResponse = productResponse
                self.recommendedCollectionView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func saveRetunPolicyPDF(pdfData: Data){
        Loader.show()
        FilesManager.shared.savePdf(pdfData: pdfData, fileName: "Return&Refund_Policy") { response in
            Loader.dismiss()
            switch response {
            case .success((_, _)):
                self.showMessage(Constants.congratulation, Constants.pdfDownloadSuccess, messageImage: .pdf, onDismiss: nil)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: UI COLLECTION VIEW
extension ProductDetailViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.imagesCollectionView:
            return productImages?.count ?? 0
            
        case self.recommendedCollectionView:
            return recommendedProductResponse?.listing?.products?.count ?? 0
            
        default:
            return similarProductResponse?.listing?.products?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.imagesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.className, for: indexPath) as! ProductImagesCell
            let item = productImages?[indexPath.row] ?? ""
            cell.configure(item)
            return cell
            
        case self.recommendedCollectionView:
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemCell.className, for: indexPath) as! ProductItemCell
            let item = recommendedProductResponse?.listing?.products?[indexPath.row]
            self.recommendedCVHeightConstraint.constant = collectionView.contentSize.height
            cell.configure(product: item)
            return cell
            
        default:
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemCell.className, for: indexPath) as! ProductItemCell
            let item = similarProductResponse?.listing?.products?[indexPath.row]
            self.similarCVHeightConstraint.constant = collectionView.contentSize.height
            cell.configure(product: item)
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.imagesCollectionView {
            let scrollPos = scrollView.contentOffset.x / imagesCollectionView.frame.width
            self.pageControl.currentPage = Int(scrollPos)
            counter = Int(scrollPos)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case imagesCollectionView:
            guard let images = productImages else { return}
            let galleryVC = GalleryImageViewController(self, imagesURL: images)
            galleryVC.showGalleryImageViewer(indexPath.row)
        case recommendedCollectionView:
            if let item = recommendedProductResponse?.listing?.products?[indexPath.row],
               let productId = item.id,
               let variant = item.variants?.first(where: {$0.isDefault == true}) ?? item.variants?.first{
                self.goToProductDetail(productId, skuId: variant.skuId ?? "")
            }
        case similarCollectionView:
            if let item = similarProductResponse?.listing?.products?[indexPath.row],
               let productId = item.id,
               let variant = item.variants?.first(where: {$0.isDefault == true}) ?? item.variants?.first{
                self.goToProductDetail(productId, skuId: variant.skuId ?? "")
            }
        default:
            break
        }
    }
}

//MARK: UICollectionView FlowLayout
extension ProductDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.imagesCollectionView:
            let interitemSpacesCount = numberOfItemPerRow - 1
            let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
            let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
            
            let width = rowContentWidth / CGFloat(numberOfItemPerRow)
            let height = width // feel free to change the height to whatever you want
            
            return CGSize(width: width, height: height)
        default:
            let interitemSpacesCount = 0
            let interitemSpacingPerRow = 1.0 * CGFloat(interitemSpacesCount)
            let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
            
            let width = rowContentWidth / CGFloat(2)
            //let height = width // feel free to change the height to whatever you want
            
            return CGSize(width: width, height: 300)
        }
        //        return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    //
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
        //        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
