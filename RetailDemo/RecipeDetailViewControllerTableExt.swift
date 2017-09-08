//
//  RecipeDetailViewControllerTableExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 06.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import UIKit
import MagicalRecord

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.arrIngridients.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(.productTableViewCell,
                                               for: indexPath) as? ProductTableViewCell else {
                                                assertionFailure("cell not inited")
                                                return UITableViewCell()
        }

        let ingridient = self.arrIngridients[indexPath.row] as Ingredient
        if let product = Product.mr_findFirst(with: NSPredicate(format: "title == %@", ingridient.productName ?? "")) {
            var isWished = product.isWished
            let productVM = ProductViewModel(product: product) { () in
				print("")
            }

 			 isWished = product.isWished
            let imBasketOk = UIImage(named: "basket_ok_2x")!
            let imColoredGreen = imBasketOk.maskWithColor(color: UIColor.darkGreen())!
            let imBasket = UIImage(named: "basket")!
            let imColoredGray = imBasket.maskWithColor(color: UIColor.lightGray)!
            cell.viewModel = ProductTableViewCell.ViewModel(
                title: productVM.title,
                price: productVM.price,
                isWished: productVM.isWished,
                coverURL: productVM.coverURL,
                selectedIcon: imColoredGreen,
                unselectedIcon: imColoredGray,
                shouldHideWishButton: false,
                wishedPressed: { _ in
                    product.isWished = !isWished
                    MagicalRecord.save(blockAndWait: { (context) in
                        let local = product.mr_(in: context)
                        local?.isWished = !isWished
                        local?.isToBuy = true
                        if local?.isWished != true {
                            local?.isToBuy = false
                        }
                    })
                    NotificationCenter.default.post(name: notificationUpdateBadge, object: nil)
                    self.tableIngredients?.reloadData()
            }

            )
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }


    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
