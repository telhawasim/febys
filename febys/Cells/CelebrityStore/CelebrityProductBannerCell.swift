//
//  CelebrityProductBannerCell.swift
//  febys
//
//  Created by Ab Saqib on 01/09/2021.
//

import UIKit

class CelebrityProductBannerCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var favouriteIcon: FebysButton!
    
    //MARK: Variable
    var productDetail: Product?
    var vendor : Vendor?
    var productId: String = ""
    var productImages: [String]?
    private var similarProductResponse: ProductResponse?
    
    private let numberOfItemPerRow = 1
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(0)
    private let minimumLineSpacing = CGFloat(0)
    
    //MARK: Register Cell
    func configure(data : Vendor?)  {
        self.vendor = data
        collectionView.register(ProductImagesCell.className)
        fetchProductDetail()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    //MARK: API Calling
    func fetchProductDetail(){
        Loader.show()
        ProductService.shared.productDetail(id: productId) { response in
            Loader.dismiss()
            switch response{
            case .success(let productDetail):
                self.productDetail = productDetail.product
                self.setData()
                self.collectionView.reloadData()
            case .failure(let error):
                print("error",error)
            }
        }
    }
    
    func setData() {
        productImages = productDetail?.variants?.first(where: {$0.isDefault == true})?.images
        self.collectionView.reloadData()
        
    }
}

//MARK: CollectionView Methods
extension CelebrityProductBannerCell:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.className, for: indexPath) as! ProductImagesCell
        let item = vendor?.templatePhoto
        cell.configuredata(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

//MARK: CollectionView Methods Flow Layout
extension CelebrityProductBannerCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interitemSpacesCount = numberOfItemPerRow - 1
        let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
        let rowContentWidth = self.collectionView.frame.size.width - sectionInset.right - sectionInset.left - interitemSpacingPerRow
        
        let width = rowContentWidth / CGFloat(numberOfItemPerRow)
        let height = width // feel free to change the height to whatever you want
      
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
