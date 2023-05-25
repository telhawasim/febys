//
//  StoreYouFollow.swift
//  febys
//
//  Created by Ab Saqib on 16/07/2021.
//

import UIKit

class StoreYouFollow: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shopNowButton: FebysButton!
    
    //MARK: Properties
    var products: [Product]?
    var didSelectProduct: ((String, String)->())?
    var shopNowButtonTapped: (()->())?

    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActionButtons()
        configureCollectionView()
    }
    
    //MARK: Helper
    func setupActionButtons() {
        shopNowButton.didTap = { [weak self] in
            self?.shopNowButtonTapped?()
        }
    }
    
    func configureCollectionView() {
        collectionView.register(ProductCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    }
    
    func configure(products: [Product]?){
        titleLabel.text = "Stores You Follow"
        detailLabel.text = "This week’s highlights"
        self.products = products
        self.collectionView.reloadData()
    }
}

//MARK: COLLECTION VIEW DELEGATES
extension StoreYouFollow:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.className, for: indexPath) as! ProductCell
        let item = products?[indexPath.row]
        cell.configure(product: item, isLarge: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedProduct = products?[indexPath.row],
           let productId = selectedProduct.id,
           let variant = selectedProduct.variants?.first(where: {$0.isDefault == true}) ?? selectedProduct.variants?.first {
            didSelectProduct?(productId, variant.skuId ?? "")
        }
    }
}

extension StoreYouFollow: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.collectionView.frame.height
        let width = height * 0.8
        return CGSize(width: width, height: height)
    }
}
