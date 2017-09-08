//
//  MapViewControllerMapExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 27.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import MapKit
import KINWebBrowser

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Shop {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.image = UIImage(named: "buble")
            return view
        }
        return nil
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
		let center = region.center
        self.showNearestShopsAtMap(c: center)

    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let shop = view.annotation as? Shop {

            PlaceLoader().getShopInfo(shop: shop, callback: {
                PlacesLoader.sharedInstance().loadDetailInformation(shop.shopID, successHanlder: { (responce) in
                    if let resp = responce as? [String: Any] {
                        if let resDict = resp["result"] as? [String: Any] {
                        let place = Place(location: CLLocation.init(latitude: shop.lat, longitude: shop.lon), reference: shop.shopID, name: shop.name ?? "", address: shop.address ?? "", types: resDict["types"] as! [Any]!)
						place?.setPlaceInfo(resDict)
                            if let placeInfoController: PlaceInfoViewController = PlaceInfoViewController(nibName: "PlaceInfoViewController", bundle: nil) as? PlaceInfoViewController {

                                 placeInfoController.setPlace(place!)
                                self.navigationController?.pushViewController(placeInfoController, animated: true, completion: { () in
                                    let btnRoute = UIButton(type: .custom)
                                    btnRoute.setTitleColor(UIColor.darkGreen(), for: .normal)
                                    btnRoute.setTitle("Route", for: .normal)
                                    let d: CGFloat = 60
                                    btnRoute.frame = CGRect(x: UIScreen.main.bounds.size.width-d-10, y: 70, width: d, height: 40)
                                    btnRoute.actionHandle(controlEvents: UIControlEvents.touchUpInside,
                                                          ForAction:
                                        {() -> Void in
                                            // open one of the 3 NaviSystems (Google, Yandex Navi, Native Apple maps)

                                            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                                                UIApplication.shared.open((NSURL(string:
                                                    "comgooglemaps://?saddr=&daddr=\(shop.lat),\(shop.lon)&directionsmode=driving")! as URL), options: [:], completionHandler: nil)
                                            } else {
                                                NSLog("Can't use comgooglemaps://");
                                                if (UIApplication.shared.canOpenURL(NSURL(string:"yandexnavi://")! as URL)) {
                                                    UIApplication.shared.open((NSURL(string:"yandexnavi://build_route_on_map?lat_to=\(shop.lat)&lon_to=\(shop.lon)")! as URL), options: [:], completionHandler: nil)
                                                } else {
                                                    UIApplication.shared.open((NSURL(string:"http://maps.apple.com/?daddr=\(shop.lat),\(shop.lon)")! as URL), options: [:], completionHandler: nil)
                                                    
                                                }
                                                
                                            }
                                    })
                                     placeInfoController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnRoute)
                                })
                            }

                        }
                    }
                }, errorHandler: { (err) in
                    print("error", err)
                })

                /*let webBrowser = KINWebBrowserViewController()

                 */


//                self.navigationController?.pushViewController(webBrowser, animated: true, completion: { () in
//                    if let url = shop.url {
//                        webBrowser.load(NSURL(string: url) as URL!)
//                    }
//                    webBrowser.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnRoute)
//                })

            })
            
            
        }
    }

    
    
}
