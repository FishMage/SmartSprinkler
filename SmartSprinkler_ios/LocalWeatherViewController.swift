//
//  LocalWeatherViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/12/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit
import WebKit
class LocalWeatherViewController: UIViewController {

    @IBOutlet weak var weatherWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://openweathermap.org/city/5261457") {
            let request = URLRequest(url: url)
            weatherWebView.loadRequest(request)
        }

        // Do any additional setup after loading the view.
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
