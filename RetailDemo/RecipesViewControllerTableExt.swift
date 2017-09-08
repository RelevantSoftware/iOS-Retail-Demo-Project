//
//  RecipesViewControllerTableExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.receipes.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueCell(.recipeTableViewCell,
                                               for: indexPath) as? RecipeTableViewCell else {
                                                assertionFailure("cell not inited")
                                                return UITableViewCell()
        }

        let recipe  = self.receipes[indexPath.row]
        print(recipe.name, recipe.id)
        cell.viewModel = RecipeViewModel(recipe: recipe)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe  = self.receipes[indexPath.row]
        if let controller = UIStoryboard.instantiateViewController(
            .recipeDetailViewController,
            inStoryboard: .recipe) as? RecipeDetailViewController {
            controller.viewModel = RecipeViewModel(recipe: recipe)
            self.navigationController?.show(controller, sender: nil)
        }

    }
}
