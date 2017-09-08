//
//  RecipeDetailViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 06.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var tableIngredients: UITableView!

    @IBOutlet weak var colletionSteps: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imViewCover: UIImageView!
    var arrIngridients : [Ingredient] = []
    var arrSteps : [RecipeStep] = []

    var viewModel: RecipeViewModel? {
        didSet {
            self.title = viewModel?.name
			self.arrIngridients = (viewModel?.ingridients)!
            self.arrSteps = (viewModel?.steps)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let w =  UIScreen.main.bounds.size.width*0.9
        var f: CGFloat = 0.85
        if (UIDevice().screenType == .iPhone5) { f=0.75 }

        let h =  UIScreen.main.bounds.size.width*f
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        colletionSteps.collectionViewLayout = layout

        self.tableIngredients?.register(UINib.nib(.productTableViewCell),
                                 forCell: .productTableViewCell)

        self.lblName?.text = self.viewModel?.name
        if let URL = self.viewModel?.imageURL {
            self.imViewCover?.sd_setImage(with: URL,
                                          placeholderImage: UIImage(assetIdentifier: .ingridientPlaceholder))
        } else {
            self.imViewCover?.image = UIImage(assetIdentifier: .ingridientPlaceholder)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
