//
//  BannerTableViewCell.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pagerController: CustomPageControl!
    
    //MARK: Properties
    private let screenWidth = UIScreen.main.bounds.width
    private var screenPadding: CGFloat = 21
    
    var banners: [HomeBanner]?
    var counter = 0
    var timer = Timer()
    var didSelectBanner: ((HomeBanner)->())?


    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        pagerController.numberOfPages = banners?.count ?? 0
        pagerController.currentPage = 0
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    //MARK: Helper
    func configureCollectionView() {
        setCollectionViewHeight()
        collectionView.register(ProductImagesCell.className)
    }
    
    func setCollectionViewHeight() {
        let width = screenWidth - (screenPadding * 2)
        let height = width * 0.905
        collectionViewHeight.constant = height
    }
    
    func configure(_ banners: [HomeBanner]){
        self.banners = banners
        self.pagerController.numberOfPages = banners.count
        self.collectionView.reloadData()
    }
    
    @objc func slide(){
        if let count = banners?.count,
           (self.collectionView.numberOfItems(inSection: 0) > 0) {
            if counter < count {
                let indexPath = IndexPath(item: counter, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                counter += 1
            } else {
                counter = 0
                let indexPath = IndexPath(item: counter, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                counter = 1
            }
        }
    }
}

//MARK: COLLECTION VIEW DELEGATES
extension BannerTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.className, for: indexPath) as! ProductImagesCell
        cell.mainImageView.setImage(url: banners?[indexPath.row].image?.first ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let banner = banners?[indexPath.row]{
           didSelectBanner?(banner)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / collectionView.frame.width
        pagerController.currentPage = Int(scrollPos)
        counter = Int(scrollPos)
    }
    
}

extension BannerTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
    }
    
}
