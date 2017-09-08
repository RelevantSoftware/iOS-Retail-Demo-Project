//
//  ProductViewModel.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 3/1/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation

protocol ProductProtocol {

    var title: String { get }
    var price: String { get }
    var isWished: Bool { get }
    var coverURL: URL? { get }
}

struct ProductViewModel: ProductProtocol {


    internal let title: String
    internal let price: String
    internal let isWished: Bool
    internal var coverURL: URL?
    var summary: String

    let wishedPressed: Action<Void>

    init(product: Product, pressed: @escaping Action<Void>) {
        title = product.title ?? ""
        let priceString = Double(product.price) / 100.0
        let formattedPrice = String(format: "%0.2f", priceString / 27)
        if let productUnit = product.unit, product.price > 0 {
            price = "Price: \(formattedPrice)$/\(productUnit)"
        } else {
            price = "Price: -/-"
        }

        if let imagesStr = product.images { // MAGiC for getting an image
            if let  imagesString = imagesStr.slice(from: "large = ", to: "medium" ){
                var urlStr = imagesString.replacingOccurrences(of: "\"", with: "")
                urlStr = urlStr.replacingOccurrences(of: " ", with: "")
                urlStr = urlStr.replacingOccurrences(of: "\n", with: "")
                coverURL = URL(string: urlStr)
            }
        }
        if (coverURL == nil) {
        	coverURL = URL(string: product.urlString ?? "")
        }


        isWished = product.isWished
        summary = product.summary ?? "No details"
        wishedPressed = pressed
    }
}
