//
//  RecipesViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView?
    var receipes : [Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib.nib(.recipeTableViewCell),
                                 forCell: .recipeTableViewCell)
        
        Recipe.arrayOfLocalRecipes {
            if let arr = Recipe.mr_findAll() as? [Recipe] {
				DispatchQueue.main.async {
               	 self.receipes = arr
                    self.tableView?.reloadData()
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
