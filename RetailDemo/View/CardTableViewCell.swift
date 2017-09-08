//
//  CardTableViewCell.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 22.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    //@IBOutlet weak var imViewCard: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
