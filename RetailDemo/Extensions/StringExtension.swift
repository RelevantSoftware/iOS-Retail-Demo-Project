//
//  StringExtansion.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 3/3/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}
