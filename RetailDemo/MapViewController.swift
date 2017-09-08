//
//  MapViewController.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 27.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let imMeColoredGreen = UIImage(named:"location3")!.maskWithColor(color: UIColor.darkGreen())!
        self.btnMe.setImage(imMeColoredGreen, for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    @IBOutlet weak var btnMe: UIButton!
    @IBAction func btnMeClick(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let regionRadius: CLLocationDistance = 100

        currentLocation = locations.last
        curUserLocation = currentLocation// obj-c
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((locations.last?.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)

        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
        if let c = currentLocation {
			self.showNearestShopsAtMap(c: c.coordinate)
        }

    }

    func showNearestShopsAtMap(c:CLLocationCoordinate2D) {
        PlaceLoader().shopsRequest(latitude: c.latitude, longitude: c.longitude, callback: {
            if let arrShops = Shop.mr_findAll() as? [Shop]{
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                }
                for shop in arrShops {
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(shop)
                    }
                }
            }
        })
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
