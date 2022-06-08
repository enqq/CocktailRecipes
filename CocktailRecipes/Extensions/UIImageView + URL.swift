//
//  UIImageView + URL.swift
//  CocktailRecipes
//
//  Created by Dawid Karpiński on 07/06/2022.
//

import Foundation
import UIKit
import RxSwift

extension UIImageView {
 
    func from(_ url: String, disposeBag: DisposeBag){
        let removeSpacing = url.replacingOccurrences(of: " ", with: "%20")
        guard  let urlAdress = URL.init(string: removeSpacing) else { return }

        URLSession.shared.rx
            .response(request: URLRequest.init(url: urlAdress))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.image = UIImage.init(data: data.data)
            },onCompleted: { [weak self] in
                UIView.animate(withDuration: 0.3) {
                    self?.alpha = 1
                        }
            }).disposed(by: disposeBag)
        
    }
}
