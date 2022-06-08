//
//  DrinkDetailsModel.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import Foundation
import SwiftyJSON

struct DrinkDetails : JsonInit {
    let drink: String
    let instructions: String
    let drinkThumb: String
    var ingredients: [String]?
    var measures: [String]?
    
    init?(json: JSON) {
        guard let singleJson = json["drinks"].array!.first else { return nil }
        
        self.drink = singleJson["strDrink"].string!
        self.instructions = singleJson["strInstructions"].string!
        self.drinkThumb = singleJson["strDrinkThumb"].string!
        
        self.ingredients = singleJson
            .filter({$0.0.contains("strIngredient")})
            .filter({$0.1 != JSON.null})
            .sorted(by: {$0.0 < $1.0})
            .map({$0.1.stringValue})
        
        self.measures = singleJson
            .filter({$0.0.contains("strMeasure")})
            .filter({$0.1 != JSON.null})
            .sorted(by: {$0.0 < $1.0})
            .map({$0.1.stringValue})
    }
    
}
