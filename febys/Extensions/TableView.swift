//
//  TableView.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import UIKit

extension UITableView{
    func register(_ name: String){
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func registerHeaderFooter(_ name: String){
        self.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }
}
