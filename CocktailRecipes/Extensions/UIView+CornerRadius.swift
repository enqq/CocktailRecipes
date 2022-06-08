//
//  UIView+CornerRadius.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import Foundation
import UIKit

extension UIView{
    func setRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
