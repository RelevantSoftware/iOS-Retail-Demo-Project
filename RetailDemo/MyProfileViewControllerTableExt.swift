//
//  MyProfileViewControllerTableExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 22.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import MagicalRecord

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.arrCards.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(.cardTableViewCell,
                                               for: indexPath) as? CardTableViewCell else {
                                                assertionFailure("cell not inited")
                                                return UITableViewCell()
        }

        let card = self.arrCards[indexPath.row]
        //cell.imViewCard.image = CardManager().getImage(code: card.code ?? "0")

        cell.lblCode.text = card.code ?? "0"
        var name = card.name ?? "Unnamed"
        if name == "" {
			name = "Unnamed"
        }
		cell.lblName.text = name
        cell.selectionStyle = .none
            return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = self.arrCards[indexPath.row]
        MagicalRecord.save(blockAndWait: {(context) in
            if let getCard = Card.mr_findFirst(with: NSPredicate(format: "\(keyCardCode) == \(card.code ?? "0")"), in: context) {
            getCard.lastSelectingDate = Date()
            }
        })
        self.imViewCard.image = CardManager().getImage(code: card.code ?? "0")
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
            self.lblTitle.alpha = 1
            self.lblNumber.alpha = 1
            self.imViewCard.alpha = 1
        }
        self.lblNumber.text = card.code ?? "0"
        self.lblTitle.text = card.name ?? ""
        rotateView(view: imViewCard, reverse: false)
        self.view.addGestureRecognizer(tapGesture!)
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("Delete", comment: "")) { action, index in
                                            let card = self.arrCards[indexPath.row]

                                            if (WCSession.default().activationState == .activated) {

                                                if (WCSession.default().isReachable)  {
                                                    WCSession.default().sendMessage(["delete": card.code ?? "0"], replyHandler: { (_) in

                                                    }, errorHandler: { (err) in
                                                        print(err.localizedDescription)
                                                    })
                                                } else {
                                                    WCSession.default().transferUserInfo(["delete":  card.code ?? "0"])
                                                }
                                                
                                            }

                                            self.arrCards.remove(at: self.arrCards.index(of: card)!)
                                            MagicalRecord.save(blockAndWait: { (context) in
                                                card.mr_deleteEntity(in: context)
                                            })


        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }

}
