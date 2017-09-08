//
//  Scanner.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 28.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class Scanner: RSCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 20, width: 100, height: 40)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(self.btnCloseClick), for: .touchUpInside)

        //self.view.addSubview(button)

        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor

        self.tapHandler = { point in
            print(point)
        }

        
        
    }
    func btnCloseClick() {
        self.dismiss(animated: true, completion:nil)
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
