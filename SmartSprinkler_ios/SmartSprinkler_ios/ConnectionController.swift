//
//  ConnectionController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/10/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {

    let alert = UIAlertController(title: "AWS IoT", message: "Device ID: SmrtSprinkler_UWiot found!", preferredStyle: UIAlertControllerStyle.alert)

    @IBOutlet weak var lblDeviceId: UILabel!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var processBar: UIProgressView!
    @IBOutlet weak var btnConnection: UIButton!
    //var progessComplete:Bool!
    var progessComplete = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnComplete.isHidden = true
        btnConnection.isEnabled = true
        lblDeviceId.isHidden = true
        processBar.isHidden = true
        
        processBar.progress = 0.00
        
        //progessComplete = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showComplete() {
        //sleep(3)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        btnConnection.setTitle("AWS Connected!", for: .normal)
        btnConnection.backgroundColor =  #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
        btnComplete.isHidden = false
        btnConnection.isEnabled = false
        lblDeviceId.isHidden = false
        
    }
    
@IBAction func btnConnectionOnClick(_ sender: Any) {
        //func updateProgress(){}
        //let progressComplete = false
        processBar.isHidden = false
    
        CATransaction.begin()
        CATransaction.setCompletionBlock({
        // do whatever you want when the animation is completed
            self.showComplete()
        })
        processBar.setProgress(3, animated: true)
        CATransaction.commit()
    }
    
    
  }
