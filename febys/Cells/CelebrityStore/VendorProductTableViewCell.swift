//
//  ProductTableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 20/12/2021.
//

import UIKit

protocol CelebrityProductDelegate {
    func productDetail(of id: String, skuId: String)
}

class VendorProductTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    private let numberOfItemPerRow = 2
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(0)
    private let minimumLineSpacing = CGFloat(0)
    
    var delegate: CelebrityProductDelegate?
    var vendor: Vendor?
    var productsCount: Int?
    var shopName: String?
    var vendorStoreID: String?
    var products: [Product]?
    
    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureCollectionView()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.contentView.frame = self.bounds
        self.layoutIfNeeded()
        return self.collectionView.contentSize
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductItemCell.className)
    }
    
    func configure(_ products: [Product]?){
        self.products = products
        self.collectionView.reloadData()
    }    
}

//MARK: CollectionView Methods
extension VendorProductTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemCell.className, for: indexPath) as! ProductItemCell
        let item = products?[indexPath.row]
        cell.configure(product: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = products?[indexPath.row]
        let varient = item?.variants?.first(where: { $0.isDefault == true }) ?? item?.variants?.first
        self.delegate?.productDetail(of: products?[indexPath.row].id ?? "", skuId: varient?.skuId ?? "")
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension VendorProductTableViewCell: UICollectionViewDelegateFlowLayout{
    
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interitemSpacesCount = 0
        let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
        let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
        
        let width = rowContentWidth / CGFloat(numberOfItemPerRow)
        //let height = width // feel free to change the height to whatever you want
        
        return CGSize(width: width, height: 300)
    }
}
