//
//  DetailsViewModel.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import Foundation
import RxSwift

class DetailsViewModel{
    
    //Depedencies
    private var disposeBag = DisposeBag()
    
    //Input
    private let api: ApiService
    private let drinkDetails: Observable<DrinkDetails>
    
    //Outputs
    let photo: Observable<UIImage>
    let drinkName: Observable<String>
    let intructions: Observable<String>
    let ingredientsCollection: Observable<[(String, String)]>
    
    init(apiService: ApiService, drinkId: Observable<String>){
        self.api = apiService
        
        //Download data by id
        drinkDetails = drinkId
            .asObservable()
            .flatMapLatest({ id in                
            return apiService.get(id, type: .details)
        }).share()

        drinkName = drinkDetails.map({$0.drink})
        intructions = drinkDetails.map({$0.instructions})
        
        //Connect two observable for UICollection
        ingredientsCollection = Observable.zip( drinkDetails.map({$0.measures}), drinkDetails.map({ $0.ingredients})){ measures, ingredients in
            var array = [(String,String)]()
            let measuresCount = (measures!.count - 1)
            for (index, value) in ingredients!.enumerated() {
                if index <= measuresCount{
                    array.append((value, measures![index]))
                } else {
                    array.append((value, " "))
                }
            }
            return array
        }
        
        //Load Photo
        photo = drinkDetails
            .map({$0.drinkThumb})
            .flatMap({ url  in
                return Observable.create(){ subscribe in
                    print(url)
                    let task = URLSession.shared.dataTask(with: URL.init(string: url)!){ data, _, _ in
                        guard let image = UIImage.init(data: data!) else { return }
                        subscribe.onNext(image)
                        subscribe.onCompleted()
                    }
                    task.resume()
                    return Disposables.create {
                        task.cancel()
                    }
                }
            })
        
    }
}
