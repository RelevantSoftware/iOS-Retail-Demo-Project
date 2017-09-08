//
//  GETProductsOperation.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation

class GETProductsOperation: APIOperation<[Product]> {

    init(at page: Int = 1, completion: Completion? = nil) {
        if page == 0 { // all local
            super.init(networkMethod: .local, path: "products2",
                       parameters: nil,
                       completion: completion)
        } else {
            super.init(networkMethod: .get, path: "products?page%5Bsize%5D=\(200)&page%5Bnumber%5D=\(page)",
                parameters: nil,
                completion: completion)
        }
    }

    init(withBarcode barcode: String = "", completion: Completion? = nil) {

        super.init(networkMethod: .get, path: "products?barcodes=\(barcode)",
                   parameters: nil,
                   completion: completion)
    }

    
    override func willProcessResponse(response: Any?) -> Any? {
        if let response = response as? [String : Any],
            let items = response["data"] as? [[String : Any]] {
            var newItems: [Any] = []
            for var item in items {
                if let attributes = item["attributes"] as? [String : Any],
                    let images = attributes["images"] as? [[String : Any]] {
                    var containFront: Bool = false
                    for image in images {
                        
                        if let categories = image["categories"] as? [String] {
                            if categories.contains("Front") {
                                item["url_string"] = image["xlarge"]
                                containFront = true
                            }
                        }
                    }
                    if !containFront {
                        item["url_string"] = images.first?["xlarge"]
                    }
                }
                newItems.append(item)
            }
            return newItems
        }
        return response
    }
}
