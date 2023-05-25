//
//  UniqueCatergoryTableViewCell.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import UIKit

class UniqueCatergoryTableViewCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var categoriesLabel: FebysLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var innerScrollView: UIImageView!
    @IBOutlet weak var scrollContainer: UIImageView!
    @IBOutlet weak var scrollBarView: UIView!

    var isUniqueCategories: Bool = true
    var categories: [UniqueCategory]?
    var vendors : [Vendor]?
    var image = ""
    var didSelectCategory: ((UniqueCategory)->())?
    var didSelectVendor: ((Vendor)->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var thisRect = innerScrollView.frame;
        thisRect.origin.x = scrollContainer.frame.origin.x
        innerScrollView.frame = thisRect
        
        collectionView.register(UniqueCategoryCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 21,
                                                   bottom: 0, right: 21)
    }
    
    func updateScrollBarUI() {
        (collectionView.contentSize.width < (collectionView.bounds.width - collectionView.contentInset.right - collectionView.contentInset.left))
        ? hideScrollBarView(true)
        : hideScrollBarView(false)
    }
    
    func hideScrollBarView(_ isHidden: Bool) {
        self.scrollBarView.isHidden = isHidden ? true : false
    }
    
    func configure(categories: [UniqueCategory]){
        self.isUniqueCategories = true
        self.categories = categories
        self.image = ""
        self.collectionView.reloadData()
        self.updateScrollBarUI()
    }
    
    func  configure(endorsments: [Vendor]?){
        self.isUniqueCategories = false
        self.categoriesLabel.text = "My Endorsements"
        self.categoriesLabel.textAlignment = .left
        self.vendors = endorsments
        self.collectionView.reloadData()
        self.updateScrollBarUI()
    }
}

//MARK: COLLECTION VIEW DELEGATES
extension UniqueCatergoryTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isUniqueCategories { return categories?.count ?? 0 }
        else { return vendors?.count ?? 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isUniqueCategories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniqueCategoryCell.className, for: indexPath) as! UniqueCategoryCell
            cell.configure(category: categories?[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniqueCategoryCell.className, for: indexPath) as! UniqueCategoryCell
            cell.configure(endorsement: vendors?[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isUniqueCategories {
            if let category = categories?[indexPath.row]{
               didSelectCategory?(category)
            }
        } else {
            if let vendor = vendors?[indexPath.row]{
               didSelectVendor?(vendor)
            }
        }
    }
}

extension UniqueCatergoryTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.collectionView.frame.height
        let width = 70.0
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollTotalOffset = scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right + scrollView.contentInset.left
        
        let scrollCurrentOffset = scrollView.contentOffset.x + scrollView.contentInset.right
        
        let newScrollTotalWidth = scrollContainer.frame.width - innerScrollView.frame.width
        let scrollPercentage = (scrollCurrentOffset * 100)/scrollTotalOffset
        
        let currentInnerPostion = (scrollPercentage/100) * newScrollTotalWidth
        var thisRect = innerScrollView.frame;
        
        thisRect.origin.x = currentInnerPostion + scrollContainer.frame.origin.x
        innerScrollView.frame = thisRect
    }
}
