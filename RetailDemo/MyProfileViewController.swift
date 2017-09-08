//
//  MyProfileViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 28.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation
import MagicalRecord


let kMyCardCode = "myCardCode"
class MyProfileViewController: UIViewController, UIGestureRecognizerDelegate {

    let scaner = Scanner ()
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imViewCard: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var alreadyPresented = false
    var tapGesture : UITapGestureRecognizer?

    @IBOutlet weak var btnScanAgain: UIBarButtonItem!
    var arrCards : [Card] = [] {
        didSet {

            self.tableView.isHidden = (arrCards.count == 0)
            btnAdd.isHidden = !(arrCards.count == 0)

            self.tableView.reloadData()

        }
    }

    @IBAction private func scanBarButtonItemPressed(barItem: UIBarButtonItem) {
        self.btnAddClick(barItem)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.nib(.cardTableViewCell),
                                forCell: .cardTableViewCell)

        self.arrCards = Card.mr_findAllSorted(by: keyCardName, ascending: true ) as! [Card]

        self.imViewCard.layer.cornerRadius = 5
        self.imViewCard.clipsToBounds = true
        self.btnAdd.layer.cornerRadius = 5
        self.btnAdd.clipsToBounds = true

        self.imViewCard.alpha = 0
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture?.delegate = self

        scaner.barcodesHandler = { barcodes in
            DispatchQueue.main.async {

                if self.alreadyPresented==false {
                    self.alreadyPresented = true
                    self.navigationController?.popViewController(animated: true)

                    let barcode = barcodes.last

                    let alert = UIAlertController(title: "Add card", message: "",
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default,
                                                  handler:
                        { (action: UIAlertAction!) in

                        guard let text = alert.textFields?.first?.text else { return }
                        //guard text.characters.count>0 else { return }

                        if let code = barcode?.stringValue {
                            if let image = RSCode128Generator(codeTable: .auto).generateCode((barcode?.stringValue)!, machineReadableCodeObjectType: AVMetadataObjectTypeCode128Code) {
                                MagicalRecord.save(blockAndWait: { (context) in
                                    let card = Card.mr_createEntity(in: context)
                                    card?.code = code
                                    card?.name = text
                                    let path =  CardManager().saveImageDocumentDirectory(image: image, code: code)

									//--watchKit session
                                    if (WCSession.default().activationState == .activated) {
                                        //--watchKit send file

                                        var c = 0
                                        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                                            let url = NSURL.fileURL(withPath: path)

                                            WCSession.default().transferFile(url, metadata: [keyCardCode : code])
                                            c = c+1
                                            if c == 3 { //hack for avoid loosing file at watch
                                                timer.invalidate()
                                            }
                                        })

                                        //--
                                        NSKeyedArchiver.setClassName(keyCardClassName, for: Card.self)
                                        if (WCSession.default().isReachable)  {
                                            let data = NSKeyedArchiver.archivedData(withRootObject: card ?? Card())
                                            WCSession.default().sendMessageData(data, replyHandler: { (answer) in
                                                print (answer)
                                            }, errorHandler: { (err) in
                                                print(err.localizedDescription)
                                            })
                                        } else {
                                            let data = NSKeyedArchiver.archivedData(withRootObject: card ?? Card())
                                            WCSession.default().transferUserInfo([keyCardClassName : data])
                                        }

                                    } /*else {
                                        let mess = "There is no connection between Watch and iPhone"
                                        print(mess)
                                        let alert = UIAlertController(title: mess, message: "",
                                                                      preferredStyle: .alert)

                                        alert.addAction(UIAlertAction(title: "OK", style: .default,
                                                                      handler: { (action: UIAlertAction!) in
                                        }))
                                        self.present(alert, animated: true)
                                    }*/
                                    //---------------------


                                })

                            }
                            self.arrCards = Card.mr_findAllSorted(by: keyCardName, ascending: true ) as! [Card]
                            if let card = Card.mr_findFirst(with: NSPredicate(format: "name == %@", text)) {

                                let i = self.arrCards.index(of: card)
                                self.tableView?.scrollToRow(at: IndexPath(row: i!, section: 0 ), at: .middle, animated: true)

                            }

                        }
                            self.alreadyPresented = false
                    }))

                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,
                                                  handler: { (action: UIAlertAction!) in
                                                    self.alreadyPresented = false
                    }))

                    alert.addTextField(configurationHandler: { (textField) in
                        textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                    })

                    self.present(alert, animated: true)

                }
            }
        }

    }

    func handleTap(_ sender: UITapGestureRecognizer) {
        rotateView(view: imViewCard, reverse: true)
        sender.view?.removeGestureRecognizer(sender)
    }

    @IBAction func btnAddClick(_ sender: Any) {
        // present(scaner, animated: true, completion: nil)
        self.navigationController?.pushViewController(scaner, animated: true)


    }

    let kRotationAnimationKey = "rotationanimationkey"
    let kZoomAnimationKey = "zoomanimationkey"
    let kMoveAnimationKey = "moveanimationkey"

    func rotateView(view: UIView, duration: Double = 0.25, reverse: Bool) {

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")

        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float(M_PI / 2.0)
        if (reverse) {
            rotationAnimation.fromValue = Float(M_PI / 2.0)
            rotationAnimation.toValue = 0.0
        }
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = 1
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.isRemovedOnCompletion = false

        zoomAnimation.fromValue = 1
        zoomAnimation.toValue = 1.4
        if (reverse) {
            zoomAnimation.fromValue = 1.4
            zoomAnimation.toValue = 1
            UIView.animate(withDuration: duration) {
                self.tableView.alpha = 1
                self.lblTitle.alpha = 0
                self.lblNumber.alpha = 0
                self.imViewCard.alpha = 0
            }


        }
        zoomAnimation.duration = duration
        zoomAnimation.repeatCount = 1
        zoomAnimation.fillMode = kCAFillModeForwards
        zoomAnimation.isRemovedOnCompletion = false

        let toPoint: CGPoint = CGPoint.init(x:0.0, y:140.0)
        let fromPoint : CGPoint = CGPoint.zero

        let movementAnimation = CABasicAnimation(keyPath: "position")
        movementAnimation.isAdditive = true
        movementAnimation.fromValue =  NSValue(cgPoint: fromPoint)
        movementAnimation.toValue =  NSValue(cgPoint: toPoint)
        if (reverse) {
            movementAnimation.fromValue = NSValue(cgPoint: toPoint)
            movementAnimation.toValue =  NSValue(cgPoint: fromPoint)
        }
        
        
        movementAnimation.duration = duration
        movementAnimation.fillMode = kCAFillModeForwards
        movementAnimation.isRemovedOnCompletion = false
        
        
        view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        view.layer.add(zoomAnimation, forKey: kZoomAnimationKey)
        view.layer.add(movementAnimation, forKey: kMoveAnimationKey)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
