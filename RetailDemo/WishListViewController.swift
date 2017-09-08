//
//  WishListViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 27.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import MagicalRecord

class WishListViewController: UIViewController, UITableViewDataSource,
     UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var viewNoItems: UIView?
    @IBOutlet private weak var searchBar: UISearchBar?
    
    @IBAction private func addBarButtonItemPressed(barItem: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add product", message: "",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            guard let text = alert.textFields?.first?.text else { return }
            guard  text.characters.count>0 else { return }

            MagicalRecord.save(blockAndWait: {(context) in
                let product = Product.mr_createEntity(in: context)
                product?.title = text
                product?.isWished = true
                product?.isToBuy = true
                product?.urlString = ""
                product?.price = 0
                product?.unit = nil
                product?.createdByUser = true
            })
            
            self.products = Product.mr_findAll(
                with: NSPredicate(format: "isWished == YES")) as! [Product]
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        })
        
        self.present(alert, animated: true)
    }
    
    private var groupedProducts: [[Product]] = [] {
        didSet {
            self.tableView?.reloadData()

            viewNoItems?.isHidden = ( groupedProducts.count != 0)
        }
    }
    
    private var products: [Product] = [] {
        didSet {
            self.groupedProducts = self.products.groupBy {
                $0.isToBuy
            }.sorted {
                $0.0.first?.isToBuy == true
            }
        }
    }
    
    private var searchText: String = "" {
        didSet {
            self.performSearch(with: self.searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib.nib(.productTableViewCell),
            forCell: .productTableViewCell)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.rowHeight = 80
        self.searchBar?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.products = Product.mr_findAll(
            with: NSPredicate(format: "isWished == YES")) as! [Product]
        self.performSearch(with: self.searchText)

    }
    
    //MARK: SearchBar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.searchBar?.text = ""
        searchBar.resignFirstResponder()
    }
    
    private func performSearch(with text: String) {
        if (text.characters.count > 0) {
            if let filtered = Product.mr_findAllSorted(by: "title", ascending: true, with:  NSPredicate(format: "isWished == YES AND title contains[c] '\(text)'")) {
                self.products = filtered as! [Product]
            } else {
            }
        } else {
            self.products = Product.mr_findAll(
                with: NSPredicate(format: "isWished == YES")) as! [Product]
        }
    }
    
    //MARK: UITableViewDataSource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedProducts.count
    }
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.groupedProducts[section].count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(.productTableViewCell,
            for: indexPath) as? ProductTableViewCell else {
            assertionFailure("cell not inited")
            return UITableViewCell()
        }
        
        let product = self.groupedProducts[indexPath.section][indexPath.row]
        let productVM = ProductViewModel(product: product) { () in
            print("")
        }
        
        let imBasketOk = UIImage(named: "uncheck_icon")!
        let imColoredGreen = imBasketOk.maskWithColor(color: UIColor.darkGreen())!
        let imBasket = UIImage(named: "check_icon")!
        let imColoredGray = imBasket.maskWithColor(color: UIColor.lightGray)!
        
        cell.viewModel = ProductTableViewCell.ViewModel(
            title: productVM.title,
            price: productVM.price,
            isWished: product.isToBuy,
            coverURL: productVM.coverURL,
            selectedIcon: imColoredGreen,
            unselectedIcon: imColoredGray,
            shouldHideWishButton: false,
            wishedPressed: { _ in
                MagicalRecord.save(blockAndWait: { (context) in
                    let local = product.mr_(in: context)
                    local?.isToBuy = !product.isToBuy
                })
                NotificationCenter.default.post(name: notificationUpdateBadge, object: nil)
                self.products = Product.mr_findAll(
                    with: NSPredicate(format: "isWished == YES")) as! [Product]
            }
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .normal,
            title: NSLocalizedString("Delete from wish list", comment: "")) { action, index in
                let product = self.groupedProducts[indexPath.section][indexPath.row]
                MagicalRecord.save(blockAndWait: { (context) in
                    let local = product.mr_(in: context)
                    local?.isWished = !product.isWished
                    local?.isToBuy = false
                })
                 NotificationCenter.default.post(name: notificationUpdateBadge, object: nil)
                self.products = Product.mr_findAll(
                    with: NSPredicate(format: "isWished == YES")) as! [Product]
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = self.groupedProducts[indexPath.section][indexPath.row]
        if let controller = UIStoryboard.instantiateViewController(
            .productTableViewController,
            inStoryboard: .product) as? ProductTableViewController {
            let productVM = ProductViewModel(product: product) { () in

                MagicalRecord.save(blockAndWait: { (context) in
                    let local = product.mr_(in: context)
                    local?.isWished = !product.isWished
                    local?.isToBuy = true
                    if local?.isWished != true {
                        local?.isToBuy = false
                    }
                })
                controller.updatBtnsUI(isWished:product.isWished)
                
            }

            controller.viewModel = productVM
            self.navigationController?.show(controller, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return self.groupedProducts[section].first?.isToBuy == true ? "To buy" : "In a basket"
    }
    
    func tableView(_ tableView: UITableView,
        willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.backgroundColor = self.groupedProducts[indexPath.section].first?.isToBuy == false ?
                UIColor.groupTableViewBackground : UIColor.white
    }
}
