//
//  FirstViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/10/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var presetSwitch: UISwitch!
    @IBOutlet weak var presetSeg: UISegmentedControl!
    @IBOutlet weak var zipcode: UILabel!
    
    var passedZip:String!
    var passedCityName:String!
    
  //  passedZip = ""
    override func viewDidLoad() {
        presetSeg.isEnabled = false
        super.viewDidLoad()
        zipcode.text = passedZip
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func locationOnClick(_ sender: UIButton) {
        
    }

    @IBAction func presetSwitchValueChange(_ sender: Any) {
        if presetSwitch.isOn {
            presetSeg.isEnabled = true
        }
        else {
            presetSeg.isEnabled = false
            
        }
    }
    
    
}

