//
//  PlaceLoader.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 02.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import Alamofire
import MagicalRecord

class PlaceLoader {
    let apiURL = "https://maps.googleapis.com/maps/api/place/"
    let apiKey = ""

    func shopsRequest(latitude:Double, longitude: Double, callback:@escaping ()->Void) {

        let additional = "nearbysearch/json?types=\("store|food|grocery_or_supermarket")&location=\(latitude),\(longitude)&rankby=distance&key=\(apiKey)"
        let str = apiURL+additional
        if let url:URL = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {
            var request = URLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

            Alamofire.request(request)
                .responseJSON
                { (responce) in

                    var succes = false
                    if let answer = responce.result.value as? NSDictionary {
                        if let results = answer["results"] as? [NSDictionary]{
                            MagicalRecord.save(blockAndWait: {(context) in
								Shop.mr_truncateAll(in: context)
                                for d in results {
                                    print(d)
                                    Shop.mr_import(from: d, in: context)
                                }
                            })
                            succes = true
                            callback()
                        }
                    }
                    if succes==false {
                        callback()
                    }
            }

        }
    }

    func getShopInfo(shop: Shop, callback:@escaping ()->Void) {
        if let shopID = shop.shopID {
            let additional = "details/json?placeid=\(shopID)&key=\(apiKey)"
            let str = apiURL+additional
            if let url:URL = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                var request = URLRequest(url: url as URL)
                request.httpMethod = "GET"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

                Alamofire.request(request)
                    .responseJSON
                    { (responce) in

                        var succes = false
                        if let answer = responce.result.value as? NSDictionary {
                            if let results = answer["result"] as? NSDictionary{
                                MagicalRecord.save(blockAndWait: {(context) in
                                    if let url = results["website"] as? String {
                                        shop.url = url
                                    } else {
                                        if let url = results["url"] as? String {
                                            shop.url = url
                                        } else {
                                            if let url = results["icon"] as? String {
                                                shop.url = url
                                            }
                                        }
                                    }
                                })
                                succes = true
                                callback()
                            }
                        }
                        if succes==false {
                            callback()
                        }
                }
            }
        }
    }
    
}
