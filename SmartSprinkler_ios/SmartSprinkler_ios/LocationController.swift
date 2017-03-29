//
//  LocationController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/10/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation


class LocationController:UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
//    @IBOutlet weak var txtCityName: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var LocMap: MKMapView!
    @IBOutlet weak var imgWeather: UIImageView!
    
    //Map View
    //var locationManager: CLLocationManager!
    let locationManager = CLLocationManager()
    
    //define alerts
    let alert = UIAlertController(title: "Location", message: "Madison, WI, 53715", preferredStyle: UIAlertControllerStyle.alert)
    let alertSearch = UIAlertController(title: "Warning", message: "Enter your City or Zipcode", preferredStyle: UIAlertControllerStyle.alert)
    let alertConfirmInfo = UIAlertController(title: "City", message: "Madison, WI, 53715", preferredStyle: UIAlertControllerStyle.alert)
    
    //Weather
    private let apiKey = "6638a13657b81ecbe08a47749ecfa9b7"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtZipcode.placeholder = "zipcode"
        //self.txtCityName.placeholder = "city name"
        imgWeather.isHidden = true
        btnSelectLocation.isEnabled = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        //Weather Code 
//       let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
//       let forecastURL = NSURL(string: "32.302452,-80.975017", relativeToURL: baseURL as! URL)
//        
//       let weatherData = NSData.dataWithContentsOfURL(forecastURL, options: nil, error: nil)
//        println(weatherData)
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        self.LocMap.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "locationToController") {
            let svc = segue!.destination as! FirstViewController
            svc.passedZip = "53715"
            //print(zipcode.text)
        }
    }
    
    @IBAction func btnSearchOnClick(_ sender: Any) {
        if txtZipcode.text != ""{
/*          //add actions to message
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
            
            //present alert
            self.present(alert, animated: true, completion: nil)
            
            sleep(1)
            cityName.text = "Madison"
            zipcode.text = txtZipcode.text
            imgWeather.isHidden = false
            btnSelectLocation.isEnabled = true
            btnSelectLocation.backgroundColor  =  #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
 */
            let zipCode = txtZipcode.text
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(zipCode!) {
                (placemarks, error) -> Void in
                // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
                
                if let placemark = placemarks?[0] {
                if let city = placemark.addressDictionary!["City"] as? String! {
                        print(city)
                    self.cityName.text = city
                    self.zipcode.text = self.txtZipcode.text
                    self.imgWeather.isHidden = false
                    self.btnSelectLocation.isEnabled = true
                    self.btnSelectLocation.backgroundColor  =  #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
                    
                    //Pass zipcode between viewControllers
                    Shared.shared.zipcode = self.zipcode.text
                    }
                }
            }
        }
        else if txtZipcode.text == ""{
            alertSearch.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertSearch, animated: true, completion: nil)
            //alertSearch.Action
        }
    }

    @IBAction func btnSelectLocationOnClick(_ sender: Any) {
              // self.performSegue(withIdentifier: "locationToController", sender: self)
    }
   
    

}
