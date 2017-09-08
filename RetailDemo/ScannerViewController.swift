//
//  ScannerViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 27.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!

    let scaner = Scanner ()

    override func viewDidLoad() {
        super.viewDidLoad()
        scaner.barcodesHandler = { barcodes in
            DispatchQueue.main.async {
                for barcode in barcodes {
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    let barcode = barcode.stringValue!
                    self.lblTitle.text = barcode

                }
                self.scaner.dismiss(animated: true, completion: {

                })
            }
        }


       	present(scaner, animated: true, completion: nil)
    }

    @IBAction func scanClick(_ sender: Any) {
        present(scaner, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
