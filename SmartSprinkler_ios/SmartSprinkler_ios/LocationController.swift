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

class LocationController:UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var txtCityName: UITextField!
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtZipcode.placeholder = "zipcode"
        txtCityName.placeholder = "city name"
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
            let svc = segue!.destination as! FirstViewController;
            svc.passedZip = zipcode.text
            //print(zipcode.text)
        }
    }
    
   
    @IBAction func btnSearchOnClick(_ sender: Any) {
        if txtZipcode.text == "53715"{
            //add actions to message
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
            
            //present alert
            self.present(alert, animated: true, completion: nil)
            
            sleep(1)
            cityName.text = "Madison"
            zipcode.text = "53715"
            imgWeather.isHidden = false
            btnSelectLocation.isEnabled = true
            btnSelectLocation.backgroundColor  =  #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
        }
        else{
            alertSearch.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertSearch, animated: true, completion: nil)
            //alertSearch.Action
        }
    }

    @IBAction func btnSelectLocationOnClick(_ sender: Any) {       
    }
   

}
