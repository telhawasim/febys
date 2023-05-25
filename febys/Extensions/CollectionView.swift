//
//  CollectionView.swift
//  febys
//
//  Created by Faisal Shahzad on 13/10/2021.
//

import UIKit

extension UICollectionView{
    func register(_ name: String){
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
