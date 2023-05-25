//
//  SeasonalOfferTableViewCell.swift
//  febys
//
//  Created by Ab Saqib on 17/07/2021.
//

import UIKit

class SeasonalOfferTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pagerController: CustomPageControl!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    private let screenWidth = UIScreen.main.bounds.width
    private var screenPadding: CGFloat = 21
    
    var offers: [Offer]?
    var counter = 0
    var timer = Timer()
    var didSelectOffer: ((Offer)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        pagerController.numberOfPages = offers?.count ?? 0
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
    
    func configure(_ offers: [Offer]){
        self.offers = offers
        self.pagerController.numberOfPages = offers.count
        self.collectionView.reloadData()
    }
    
    @objc func slide(){
        if let count = offers?.count,
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
extension SeasonalOfferTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.className, for: indexPath) as! ProductImagesCell
        cell.mainImageView.setImage(url: offers?[indexPath.row].image?.first ?? "")
        cell.mainImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let offer = offers?[indexPath.row]{
           didSelectOffer?(offer)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / collectionView.frame.width
        pagerController.currentPage = Int(scrollPos)
        counter = Int(scrollPos)
    }
    
}

extension SeasonalOfferTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
    }
}
