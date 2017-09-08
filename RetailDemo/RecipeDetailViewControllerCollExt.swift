//
//  RecipeDetailViewControllerCollExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 06.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import UIKit

 let identifier = "RecipeStepCollectionViewCell"

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSteps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! RecipeStepCollectionViewCell

        cell.lblStep.text = "Step \(indexPath.row + 1)"
        let step = arrSteps[indexPath.row]
        cell.lblText.text = step.text ?? ""
        if let URL = URL(string: step.image ?? "") {
            cell.imViewPicture?.sd_setImage(with: URL,
                                             placeholderImage: UIImage(assetIdentifier: .ingridientPlaceholder))
        } else {
            cell.imViewPicture?.image = UIImage(assetIdentifier: .ingridientPlaceholder)
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
