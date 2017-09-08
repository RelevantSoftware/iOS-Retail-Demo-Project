//
//  RecipeTableViewCell.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 06.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblTitle: UILabel?
    @IBOutlet private weak var imViewCover: UIImageView?

    var viewModel: RecipeViewModel? {
        didSet {
            self.setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.lblTitle?.text = self.viewModel?.name
        if let URL = self.viewModel?.imageURL {
            self.imViewCover?.sd_setImage(with: URL,
                                             placeholderImage: UIImage(assetIdentifier: .ingridientPlaceholder))
        } else {
            self.imViewCover?.image = UIImage(assetIdentifier: .ingridientPlaceholder)
        }
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
