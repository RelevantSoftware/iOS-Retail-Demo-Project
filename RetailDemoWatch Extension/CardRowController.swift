//
//  CardRowController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 24.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import WatchKit

class CardRowController: NSObject {


    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var lblName: WKInterfaceLabel!
    var card: Card? {
        didSet {
            if let card = card {
				lblName.setText(card.name ?? "")
            }
        }
    }
}
