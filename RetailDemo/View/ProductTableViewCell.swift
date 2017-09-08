//
//  ProductTableViewCell.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import SDWebImage

 typealias Action<T> = (T) -> Void

class ProductTableViewCell: UITableViewCell {
    
    struct ViewModel: ProductProtocol {
        

        internal let title: String
        internal let price: String
        internal let isWished: Bool
        internal let coverURL: URL?
        let selectedIcon: UIImage
        let unselectedIcon: UIImage
        
        let shouldHideWishButton: Bool
        
        let wishedPressed: Action<Void>
    }
    
    var viewModel: ViewModel? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var coverImageView: UIImageView?
    @IBOutlet private weak var wishButton: UIButton?
    
    @IBAction private func wishButtonPressed(button: UIButton) {
        self.viewModel?.wishedPressed()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel?.text = self.viewModel?.title ?? ""
        self.priceLabel?.text = self.viewModel?.price ?? ""
        self.wishButton?.isSelected = self.viewModel?.isWished == true
        self.wishButton?.isHidden = self.viewModel?.shouldHideWishButton == true
        if let URL = self.viewModel?.coverURL {
            self.coverImageView?.sd_setImage(with: URL,
                placeholderImage: UIImage(assetIdentifier: .productPlaceholder))
        } else {
            self.coverImageView?.image = UIImage(assetIdentifier: .productPlaceholder)
        }

        self.wishButton?.setImage(self.viewModel?.unselectedIcon ?? UIImage(),
                                  for: .normal)
        self.wishButton?.setImage(self.viewModel?.selectedIcon ?? UIImage(),
                                  for: .selected)
    }
}
