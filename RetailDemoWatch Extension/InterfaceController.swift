//
//  InterfaceController.swift
//  RetailDemoWatch Extension
//
//  Created by Alexey Romanko on 23.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import WatchKit
import Foundation
import MagicalRecord
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var table: WKInterfaceTable!
    var session : WCSession!


    var arrCards: [Card] = []
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

    }

    func updateTable() {
        self.arrCards = Card.mr_findAllSorted(by: keyCardSelectingDate, ascending: true ) as! [Card]

        table.setNumberOfRows(self.arrCards.count, withRowType: "CardRow")
        for card in arrCards {
            print(card.name ?? "__")
        }
        for index in 0..<self.arrCards.count {
            if let controller = table.rowController(at: index) as? CardRowController {
                controller.card = self.arrCards[index]
            }
        }
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {

        let card = arrCards[rowIndex]
        presentController(withName: "CardDetailInterfaceController", context: card)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.updateTable()

        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }

    }

    //MARK: - instance session
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message \(message)")
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        print("message replyHandler \(message)")

        replyHandler(["answer":"ok from watch"])
        if let codeToDelete = message["delete"] as? String{
            Card.deleteFromStorageCardWithCode(code: codeToDelete)
        }
         self.updateTable()
    }

    public func session(_ session: WCSession, didReceiveMessageData messageData: Data) {

    }

    public func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Swift.Void) {
        Card.unArchiveAndSaveCard(data: messageData) // saving data received from iOS
        updateTable()
    }

    //MARK: - background session
    public func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]){
        DispatchQueue.main.async {
            if let codeToDelete = userInfo["delete"] as? String{
                Card.deleteFromStorageCardWithCode(code: codeToDelete)
            } else {

                if let messageData =  userInfo[keyCardClassName] as? Data {
                    Card.unArchiveAndSaveCard(data: messageData) // saving data received from iOS

                }
            }
             self.updateTable()
        }
    }

    //MARK: - file session
    public func session(_ session: WCSession, didReceive file: WCSessionFile){
       DispatchQueue.main.async {

        if let metadata = file.metadata {
            if let code = metadata[keyCardCode] as? String
            {
                if let imageData = NSData.init(contentsOf: file.fileURL) as? Data {
                    if let im = UIImage(data: imageData) {
                       let p = CardManager().saveImageDocumentDirectory(image: im, code: code)
                        print (p)
                    }
                }
            }
        }
        }
    }

    //MARK: -
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
