//
//  SearchViewModel.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 04/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    //input
    private let apiService: ApiService
    
    //Output
    let drinksObservable: Observable<DrinksModel>
    
    //Input
    let searchText = PublishSubject<String>()
    
    init(apiService: ApiService){
        self.apiService = apiService
        
        //Observable search ingredient next query on api
        drinksObservable = searchText.asObservable()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ search in
                return apiService.get(search, type: .search)
        })
    }
}
