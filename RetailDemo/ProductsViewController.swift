//
//  ProductsViewController.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import SDWebImage
import MagicalRecord

let notificationUpdateBadge = Notification.Name("notificationUpdateBadge")

class ProducsViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet private weak var tableView: UITableView?

    @IBOutlet private weak var searchBar: UISearchBar?

    var curPage = 1
    let scaner = Scanner ()

    @IBAction private func addBarButtonItemPressed(barItem: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add product", message: "",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default,
            handler: { (action: UIAlertAction!) in

            guard let text = alert.textFields?.first?.text else { return }
            guard text.characters.count>0 else { return }

            MagicalRecord.save(blockAndWait: {(context) in
                let product = Product.mr_createEntity(in: context)
                product?.title = text
                product?.isWished = false
                product?.isToBuy = false
                product?.urlString = ""
                product?.price = 0
                product?.unit = nil
                product?.createdByUser = true
            })
            
                self.products = Product.mr_findAllSorted(by: "title", ascending: true , with: NSPredicate(format: "title.length > 0")) as! [Product]
                if let prod = Product.mr_findFirst(with: NSPredicate(format: "title == %@", text)) {

                let i = self.products.index(of: prod)
                self.tableView?.scrollToRow(at: IndexPath(row: i!, section: 0 ), at: .middle, animated: true)
                }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,
            handler: { (action: UIAlertAction!) in
        }))
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        })
        
        self.present(alert, animated: true)
    }

    @IBAction private func scanBarButtonItemPressed(barItem: UIBarButtonItem) {
        var controlValue = 0
        scaner.barcodesHandler = { barcodes in
            DispatchQueue.main.async {
                print("bar code finded \(controlValue)")
                controlValue = controlValue + 1
                if (controlValue <= 1) {
                    for barcode in barcodes {
                        print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                        let barcode = /*barcode.stringValue!*/ "8437002948153"

                        self.navigationController?.popViewController(animated: false)
                        if let product = Product.mr_findFirst(with: NSPredicate(format: "barcode == %@", barcode))
                        {
                            self.showDetailForProduct(product: product)
                        } else {
                            GETProductsOperation(withBarcode: barcode) { (products, _) in
                                if let p = products?.first {
                                    self.showDetailForProduct(product: p)
                                } else {
                                    let alert = UIAlertController(title: "There is no product with this barcode", message: "",
                                                                  preferredStyle: .alert)

                                    alert.addAction(UIAlertAction(title: "OK", style: .default,
                                                                  handler: { (action: UIAlertAction!) in

                                    }))
                                    
   								self.present(alert, animated: true)


                                }
                                }.start()

                        }
                        
                        
                    }
                }
            }
        }
        

        self.navigationController?.pushViewController(scaner, animated: true)
       	//present(scaner, animated: true, completion: nil)

    }

    
    var products: [Product] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    private var searchText: String = "" {
        didSet {
			self.performSearch(with: self.searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar?.delegate = self
        self.tableView?.register(UINib.nib(.productTableViewCell),
            forCell: .productTableViewCell)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.rowHeight = 80

        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpdatedBadge), name: notificationUpdateBadge, object: nil)

        GETProductsLocalOperation() { (products, _) in
            let  arrProductlocal = Productlocal.mr_findAllSorted(by: "title",
                                                     ascending: true) as! [Productlocal]
            print (arrProductlocal)
            MagicalRecord.save(blockAndWait: { (context) in
                for localProd in arrProductlocal {
                    let alreadyExistedProducts = Product.mr_findAll(with: NSPredicate(format: "title == '\(localProd.title ?? "0")'"), in: context)
                    if alreadyExistedProducts?.count == 0 {
                        let prod = Product.mr_createEntity(in: context)
                        prod?.isWished = localProd.isWished
                        prod?.isToBuy = localProd.isToBuy
                        prod?.price = localProd.price
                        prod?.summary = localProd.summary
                        prod?.title = localProd.title
                        prod?.unit = localProd.unit
                        prod?.urlString = localProd.urlString
                        prod?.productID = localProd.title ?? "0"
                    }
                }

            })
            }.start()


       // GETProductsOperation(at: curPage) { (products, _) in
         GETProductsOperation(at: 0) { (products, _) in
            self.products = Product.mr_findAllSorted(by: "title", ascending: true , with: NSPredicate(format: "title.length > 0")) as! [Product]
            //self.products = Product.mr_findAllSorted(by: "title", ascending: true) as! [Product]
            }.start()

		self.setUpdatedBadge()

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            if let filtered = Product.mr_findAllSorted(by: "title",
                ascending: true, with:  NSPredicate(
                format: "title contains[c] '\(text)'")) {
                products = filtered as! [Product]
            } else {
            }
        } else {
            products = Product.mr_findAllSorted(by: "title", ascending: true , with: NSPredicate(format: "title.length > 0")) as! [Product]
        }
        self.tableView?.reloadData()
    }
    
    //MARK: UITableViewDataSource methods

    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(.productTableViewCell,
            for: indexPath) as? ProductTableViewCell else {
            assertionFailure("cell not inited")
            return UITableViewCell()
        }
        
        let product = self.products[indexPath.row]
        let productVM = ProductViewModel(product: product) { () in
            print("")
        }
        let isWished = product.isWished
        
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
                self.setUpdatedBadge()
                self.tableView?.reloadData()
            }
        )

        if ((indexPath.row>10) && (indexPath.row==self.products.count-10))  {
            curPage = curPage + 1
            GETProductsOperation(at: curPage) { (products, _) in
                self.products = Product.mr_findAllSorted(by: "title", ascending: true , with: NSPredicate(format: "title.length > 0")) as! [Product]
                }.start()
        }
        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let product = self.products[indexPath.row]
        return product.createdByUser == true

    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("Delete", comment: "")) { action, index in
                                            let product = self.products[indexPath.row]
                                            self.products.remove(at: self.products.index(of: product)!)
                                            MagicalRecord.save(blockAndWait: { (context) in
                                                product.mr_deleteEntity(in: context)
                                            })


        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        
    }


    
    //MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = self.products[indexPath.row]
        showDetailForProduct(product: product)
    }

    func showDetailForProduct(product: Product) {
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

    @objc func setUpdatedBadge() {
        if let arrIsToBuy = Product.mr_findAll(with: NSPredicate(format:"isToBuy == YES")) as? [Product] {
            let count = arrIsToBuy.count
            if (count==0) {
                self.tabBarController?.tabBar.items?[2].badgeValue = nil
            } else {
            	self.tabBarController?.tabBar.items?[2].badgeValue = "\(arrIsToBuy.count)"
            }
        }

    }
}
