//
//  UICollectionView.swift
//  febys
//
//  Created by Ab Saqib on 01/09/2021.
//

import UIKit

extension UICollectionView{
    func register(_ name: String){
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
