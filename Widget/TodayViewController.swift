//
//  TodayViewController.swift
//  Widget
//
//  Created by Alexey Romanko on 28.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import NotificationCenter
import MagicalRecord

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!

    @IBOutlet weak var imCode: UIImageView!

    var arrCards : [Card] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOSApplicationExtension 10.0, *) { // Xcode would suggest you implement this.
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }

        let sharedContainerURL: NSURL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kGroupName) as NSURL?
        if let sharedContainerURL = sharedContainerURL {
            if let storeURL = sharedContainerURL.appendingPathComponent(kSqlFileName) {
                MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: storeURL)
            }
        }
        
        self.arrCards = Card.mr_findAllSorted(by: keyCardSelectingDate, ascending: false ) as! [Card]

        if let card = self.arrCards.first {
            lblName.text = card.name ?? "Unnamed"
            lblCode.text = card.code ?? ""
            if let image = CardManager().getImage(code: card.code ?? "0") {
				imCode.image = image
            } else {
                imCode.image = nil
            }
        }

    }


    @IBAction func btnToAppClick(_ sender: Any) {
           extensionContext?.open(URL(string: "Relevant.RetailDemo://")! , completionHandler: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 220)
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}


