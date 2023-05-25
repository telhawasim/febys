//
//  WishListViewController.swift
//  febys
//
//  Created by Ab Saqib on 13/07/2021.
//

import UIKit

class WishListViewController: BaseViewController{
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wishlistLabel: FebysLabel!
    
    //MARK: Properties
    var count = 0
    var pageNo = 1
    var pageSize = 15
    var wishListProducts: ProductResponse?
    var isLoading = true
    
    private let numberOfItemPerRow = 2
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(0)
    private let minimumLineSpacing = CGFloat(0)
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWishlist()
    }
    
    //MARK: Helpers
    func setUpCollectionView() {
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(ProductItemCell.className)
        collectionView.register(EmptyViewsCollectionViewCell.className)
    }
    
    //MARK: API CALLS
    func fetchWishlist(){
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo: pageNo] as [String : Any]
        
        Loader.show()
        WishListService.shared.getWishList(params: params) { response in
            Loader.dismiss()
            switch response{
            case .success(let wishlist):
                self.count = wishlist.listing?.totalRows ?? 0
                self.wishlistLabel.text = "Wishlist (\(self.count))"
                
                if self.wishListProducts == nil{
                    self.wishListProducts = wishlist
                }else{
                    self.wishListProducts?.listing?.products?.append(contentsOf: wishlist.listing?.products ?? [])
                }
                
                self.isLoading = false
                self.collectionView.reloadData()
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

extension WishListViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if wishListProducts?.listing?.products?.count ?? 0 == 0{ return 1 }else{
                return wishListProducts?.listing?.products?.count ?? 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if wishListProducts?.listing?.products?.count ?? 0 == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyViewsCollectionViewCell.className, for: indexPath) as! EmptyViewsCollectionViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenWishListDescription)
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemCell.className, for: indexPath) as! ProductItemCell
            
            let item = self.wishListProducts?.listing?.products?[indexPath.row]
            cell.configure(product: item, forWishlist: true)
            
            cell.cellButton.didTap = {
                if let id = item?.variants?.first?.skuId{
                    self.wishListProducts?.listing?.products?.remove(at: indexPath.row)
                    self.count = self.count - 1
                    self.wishlistLabel.text = "Wishlist (\(self.count))"
                    self.collectionView.reloadData()
                    WishlistManager.shared.removefromWishlist(variantId: id)
                }
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == ((wishListProducts?.listing?.products?.count ?? 0) - 3){
            if (pageNo + 1) <= wishListProducts?.listing?.paginationInfo?.totalPages ?? 0{
                pageNo += 1
                fetchWishlist()
            }
        }
    }
}

//MARK: ColledctionView Flow Layout
extension WishListViewController:UICollectionViewDelegateFlowLayout{
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
        if wishListProducts?.listing?.products?.count ?? 0 == 0{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else{
            let interitemSpacesCount = numberOfItemPerRow - 1
            let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
            let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
            let width = rowContentWidth / CGFloat(numberOfItemPerRow)
            return CGSize(width: width, height: 300)
        }
    }
}
