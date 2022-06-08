//
//  SearchViewController.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 04/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    //MARK: - Depedencies
    private var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: - Outlets
    @IBOutlet weak var textSearchBar: UISearchBar!
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel(apiService: ApiService())
        
        setupView()
        bindToViewModel()
    }
    
    private func setupView(){
        self.drinksCollectionView.delegate = self
        self.textSearchBar.becomeFirstResponder()
        addGesture()
        registerCell()
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        if textSearchBar.isFirstResponder{
        textSearchBar.resignFirstResponder()
        }
    }
    
    private func registerCell(){
        self.drinksCollectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeCell")
    }
    
    //MARK: - Bind To ViewModel
    private func bindToViewModel() {
        
        viewModel.drinksObservable
            .map({$0.drinks})
            .subscribe(on: MainScheduler.asyncInstance)
            .bind(to: drinksCollectionView.rx.items(cellIdentifier: "recipeCell", cellType: RecipeCollectionViewCell.self)){ (index, drink, cell) in
                cell.set(name: drink.drink, imageUrl: drink.drinkThumb)
            }.disposed(by: disposeBag)
        
        textSearchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        drinksCollectionViewTaped()
        
    }

    private func drinksCollectionViewTaped() {
        
        drinksCollectionView.rx
            .modelSelected(DrinkModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] drink in
                
                let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                nextVC.drinkId.onNext(drink.idDrink)
                let navigationVC = UINavigationController(rootViewController: nextVC)
                present(navigationVC, animated: true)
                
            }).disposed(by: disposeBag)
    }

}
//Responsibility cell
extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellSpacing = CGFloat(20)
         let leftRightMargin = CGFloat(40)
         let numColumns = CGFloat(2)

         let totalCellSpace = cellSpacing * (numColumns - 1)
        let screenWidth = UIScreen.main.bounds.width
         let width = (screenWidth - leftRightMargin - totalCellSpace) / 2
        
         let height = CGFloat(140)
        print(width)
        return CGSize(width: width, height:height);
    }

}
