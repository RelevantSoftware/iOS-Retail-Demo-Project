//
//  CardDetailInterfaceController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 24.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import WatchKit
import Foundation


class CardDetailInterfaceController: WKInterfaceController {

    @IBOutlet var lblName: WKInterfaceLabel!
    @IBOutlet var lblCode: WKInterfaceLabel!
    @IBOutlet var imageCode: WKInterfaceImage!

    var card: Card? {
        didSet {
            if let card = card {
                lblCode.setText(card.code ?? "")
                imageCode.setImage(CardManager().getImage(code: card.code ?? "0"))
                self.setTitle(card.name ?? "")
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let card = context as? Card {
			self.card = card
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
