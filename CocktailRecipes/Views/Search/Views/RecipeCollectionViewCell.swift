//
//  RecipeCollectionViewCell.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 04/06/2022.
//

import UIKit
import RxSwift

class RecipeCollectionViewCell: UICollectionViewCell {

    private let disposeBag = DisposeBag()
    

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerCell()
    }
    
    private func cornerCell(){
        self.cellBackgroundView.setRadius(radius: 16)
        self.cellBackgroundView.layer.borderWidth = 1
        self.cellBackgroundView.layer.borderColor = UIColor.systemGray.cgColor
    
    }
    
    internal func set(name: String, imageUrl: String){
        nameLabel.text = name
        photoImageView.from(imageUrl, disposeBag: disposeBag)
    }
    
}
