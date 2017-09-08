//
//  RecipeViewModel.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 06.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
protocol RecipeProtocol {

    var name: String { get }
    var imageURL: URL? { get }
    var ingridients: [Ingredient]? { get }
    var steps: [RecipeStep]? { get }
}

struct RecipeViewModel: RecipeProtocol {

    internal let name: String
    internal let imageURL: URL?
    internal let ingridients: [Ingredient]?
    internal let steps: [RecipeStep]?

    init(recipe: Recipe) {

        name = recipe.name ?? ""

        if let steps = recipe.steps?.allObjects as? [RecipeStep] {
            let sortdetSteps = steps.sorted(by: { (s1, s2) -> Bool in
                return (s1.order < s2.order)
            })
            self.steps = sortdetSteps
            let imageURL = URL(string: sortdetSteps.last?.image ?? "")

           self.imageURL = imageURL
        } else {
            self.imageURL = nil
            self.steps = nil
        }

        ingridients = recipe.ingridients?.allObjects as? [Ingredient]
    }
}



