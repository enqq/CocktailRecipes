//
//  ApiService.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 04/06/2022.
//
import Foundation
import RxSwift
import SwiftyJSON
import UIKit

class ApiService {
    
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    //Type request
    internal enum pathNavigator: String {
        case search = "filter.php?i=",
             details = "lookup.php?i="
    }
    
    //Get data with Api
    func get<T: JsonInit>(_ value: String, type: pathNavigator) -> Observable<T> {
        Observable.create(){ [unowned self] subscribe in
            
        let convertUrl = "\(baseUrl)\(type.rawValue)\(value)".replacingOccurrences(of: " ", with: "%20")
            guard let urlAdress = URL.init(string: convertUrl) else {
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: urlAdress) { data, _, _ in
                guard let data = data, let json  = try? JSON(data: data) else {
                    return
                }

                subscribe.onNext(T.init(json: json)!)
                subscribe.onCompleted()
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
}

protocol JsonInit {
    init?(json: JSON)
}
