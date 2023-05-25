//
//  MenuViewController.swift
//  febys
//
//  Created by Abdul Kareem on 06/10/2021.
//

import UIKit

struct MenuItem {
    let title: String
    let icon: String
    
    static func getMenuItems() -> [MenuItem] {
        var data = [MenuItem]()
//        data.append(MenuItem(title: Constants.FebysPlus, icon: "FebysPlus"))
        data.append(MenuItem(title: Constants.DiscountMall, icon: "DiscountMall"))
//        data.append(MenuItem(title: Constants.PawnShop, icon: "PawnShop"))
        data.append(MenuItem(title: Constants.MadeInGhana, icon: "MadeGhana"))
        data.append(MenuItem(title: Constants.AfricanMarket, icon: "AfricanMarket"))
        data.append(MenuItem(title: Constants.ThriftMarket, icon: "ThriftMarket"))
        return data
    }
    
}

class MenuViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems = MenuItem.getMenuItems()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableViewCell.className)
    }
    
    //MARK: Navigation
    func goToFebysPlus(){
        let vc = UIStoryboard.getVC(from: .FebysPlus, FebysPlusViewController.className) as! FebysPlusViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductList(title: String, filterType: FilterType, _ repo: ProductRepository){
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.titleName = title
        vc.filterType = filterType
        vc.repo = repo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: TableView Methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = menuItems[indexPath.row].title
        cell.iconimage.image = UIImage(named: menuItems[indexPath.row].icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menuItems[indexPath.row].title {
        case Constants.FebysPlus:
            //            self.goToFebysPlus()
            self.showMessage("Coming Soon", "Febys Plus subscription feature is coming soon", messageImage: .upcomming, onDismiss: nil)
            
        case Constants.DiscountMall:
            self.goToProductList(title: Constants.DiscountMall, filterType: .none, DiscountedProductsRepository())
        case Constants.MadeInGhana:
            self.goToProductList(title: Constants.MadeInGhana, filterType: .none, SpecialStorsRepository(.MadeInGhana))
        case Constants.AfricanMarket:
            self.goToProductList(title: Constants.AfricanMarket, filterType: .none, SpecialStorsRepository(.AfricanMarket))
        case Constants.ThriftMarket:
            self.goToProductList(title: Constants.ThriftMarket, filterType: .none, SpecialStorsRepository(.ThriftMarket))
        case Constants.PawnShop:
            self.showMessage("Coming Soon", "Pawn Shop feature is coming soon", messageImage: .upcomming, onDismiss: nil)
        default:
            break
        }
    }
}

enum SpecialFilter: String {
    case ThriftMarket = "Thrift Market"
    case MadeInGhana = "Made in Ghana"
    case AfricanMarket = "African Market"
    case DiscountMall = "Discount Mall"
    
}
