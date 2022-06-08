//
//  DrinksModel.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 04/06/2022.
//

import Foundation
import SwiftyJSON

struct DrinksModel: JsonInit {
    init?(json: JSON) {
        guard let drinks = json["drinks"].array else {
            print(json )
            return nil
        }
        self.drinks = drinks.compactMap(DrinkModel.init)
    }
    
    let drinks: [DrinkModel]
}

struct DrinkModel: JsonInit {
    init?(json: JSON) {
        guard let strDrink = json["strDrink"].string,
              let strDrinkThumb = json["strDrinkThumb"].string,
              let idDrink = json["idDrink"].string
        else {
            return nil
        }
        (self.drink, self.drinkThumb, self.idDrink) = (strDrink, strDrinkThumb, idDrink)
    }
    
    let drink: String
    let drinkThumb: String
    let idDrink: String
    
}
