//
//  DetailsViewController.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {

    //MARK: - Depedencies
    private var viewModel: DetailsViewModel!
    private var disposeBag = DisposeBag()
    var drinkId = BehaviorSubject<String>(value: "")
    
    //MARK: -Outlets
    @IBOutlet weak var intructionsTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ingredientCollectionView: UICollectionView!
    //MARK: - Lifecycles
    
    //BlurEffect with photo
    private var backgroundImageView: UIImageView {
        let backgroundImage = UIImageView.init(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        backgroundImage.autoresizesSubviews = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
        
        viewModel.photo
            .bind(to: backgroundImage.rx.image)
            .disposed(by: disposeBag)
        
        return backgroundImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailsViewModel(apiService: ApiService(), drinkId: drinkId.asObservable())
        setupView()
        bindToViewModel()
    }
    
    //Set view for components
    private func setupView(){
        setBackgroundView()
        registerCell()
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: nil)
        self.intructionsTextView.setRadius(radius: 14)
        self.photoImageView.setRadius(radius: 16)
        
    }
    
    private func registerCell(){
        self.ingredientCollectionView.register(UINib(nibName: "IngredientCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ingredientCell")
    }
    
    //Add photo and blueffect on the background
    private func setBackgroundView(){
        self.view.backgroundColor = .clear
        self.view.insertSubview(backgroundImageView, at: 0)
    }

    
    //MARK: - Bind To ViewModel
    private func bindToViewModel(){
        
        viewModel.drinkName
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.photo
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.intructions
            .bind(to: intructionsTextView.rx.text)
            .disposed(by: disposeBag)
        
        ingredientCollectionView.dataSource = nil
        viewModel.ingredientsCollection
            .bind(to: ingredientCollectionView.rx.items(cellIdentifier: "ingredientCell", cellType: IngredientCollectionViewCell.self)){ (index, ingredient, cell) in
                cell.set(ingredient.0, ingredient.1)
            }.disposed(by: disposeBag)
        
        leftBarButtomTaped()
    }
    
    private func leftBarButtomTaped(){
        
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
    

}
