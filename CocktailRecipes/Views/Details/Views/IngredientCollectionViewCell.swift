//
//  IngredientCollectionViewCell.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import UIKit
import RxSwift
class IngredientCollectionViewCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var backgroundUIView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
         setupView()
    }
    
    private func setupView(){
        self.backgroundUIView.setRadius(radius: 14)
    }
    
    internal func set(_ ingredient: String, _ measure: String){
        let url = "https://www.thecocktaildb.com/images/ingredients/\(ingredient)-Small.png"
        self.nameLabel.text = ingredient
        self.measureLabel.text = measure
        self.photoImageView.from(url, disposeBag: disposeBag)
    }

}
