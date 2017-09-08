//
//  ProducttableViewController.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 3/3/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import SDWebImage

class ProductTableViewController: UITableViewController {
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var summaryLabel: UILabel?
    var tapImage : UITapGestureRecognizer?
    var bigImageView: UIImageView?


    var viewModel: ProductViewModel?

    @IBAction func btnAddClick(_ sender: Any) {
        self.viewModel?.wishedPressed()
        NotificationCenter.default.post(name: notificationUpdateBadge, object: nil)
        
    }

    func updatBtnsUI(isWished:Bool) {
        if (isWished) {
            self.btnAdd.image = UIImage(named: "basket_ok")
            //TODO : it doesn't work because of UIView.appearance().tintColor = UIColor.darkGreen()
            //self.btnAdd.tintColor = UIColor.green // UINavigationBar.appearance().tintColor
        } else {
           	self.btnAdd.image = UIImage(named: "basket_2")
            //self.btnAdd.tintColor = UIColor.lightGray
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel?.text = self.viewModel?.title ?? ""
        self.priceLabel?.text = self.viewModel?.price ?? ""
        self.summaryLabel?.text = self.viewModel?.summary ?? ""
		self.updatBtnsUI(isWished: (self.viewModel?.isWished)!)

        if let URL = self.viewModel?.coverURL {
            self.imageView?.sd_setImage(with: URL,
                placeholderImage: UIImage(assetIdentifier: .productPlaceholder))
        } else {
            self.imageView?.image = UIImage(assetIdentifier: .productPlaceholder)
        }

        tapImage = UITapGestureRecognizer(target: self, action: #selector(makeLarger(gesture:)))
        self.tableView?.addGestureRecognizer(tapImage!)
    }

    func makeLarger(gesture: UIGestureRecognizer) {
        let p = gesture.location(in: gesture.view!)

        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let touchArea: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.25)
        if (touchArea.contains(p)) {
            if (self.bigImageView == nil) {
                self.bigImageView = UIImageView(frame: (self.imageView?.frame)!)
                self.bigImageView?.contentMode = .scaleAspectFill
            }
            self.bigImageView!.alpha = 0
            self.bigImageView?.image = imageView?.image
            self.tableView.addSubview(self.bigImageView!)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.bigImageView!.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.bigImageView!.alpha = 1

            }) { (success) in

            }

            self.tableView.removeGestureRecognizer(tapImage!)

            let tapImageSmaller = UITapGestureRecognizer(target: self, action: #selector(makeSmaller(gesture:)))
            self.tableView?.addGestureRecognizer(tapImageSmaller)
        }
        
    }

    func makeSmaller(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
        	self.bigImageView!.frame = (self.imageView?.frame)!
            self.bigImageView!.alpha = 0
        }) { (success) in
			self.bigImageView!.removeFromSuperview()
            self.tableView?.addGestureRecognizer(self.tapImage!)
        }
    }

    
    //MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                //width and height of summaryLabel
                let width = UIScreen.main.bounds.size.width - 32
                let extraHeight: CGFloat = 25
                if let text = self.summaryLabel?.text,
                    let font = self.summaryLabel?.font {
                    return text.heightWithConstrainedWidth(width: width,
                        font: font) + extraHeight
                } else {
                    return 0.0
                }
            default: return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
