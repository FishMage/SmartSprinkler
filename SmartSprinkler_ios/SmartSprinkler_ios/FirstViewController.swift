//
//  FirstViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/10/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var swcAuto: UISwitch!
    @IBOutlet weak var presetSwitch: UISwitch!
    @IBOutlet weak var presetSeg: UISegmentedControl!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var lblPrecipitation: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var passedZip:String!
    var passedCityName:String!
    
  //  passedZip = ""
    override func viewDidLoad() {
        presetSeg.isEnabled = false
        super.viewDidLoad()
        
        if zipcode.text == "/" {
            btnConfirm.isEnabled = false
            print("Zipcode not specified")
        }else{
            btnConfirm.isEnabled = true
            btnConfirm.backgroundColor = #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
            print("Zipcode is specified")
        }
        //get shared value
        if (Shared.shared.zipcode) != nil {
            passedZip = Shared.shared.zipcode
            zipcode.text = passedZip
            btnConfirm.isEnabled = true
            btnConfirm.backgroundColor = #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
            print("Successfully get Zipcode Value")
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func locationOnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnConfirmOnClick(_ sender: Any) {
        //Set up variable for confrim view
        Shared.shared.confirmedZip = zipcode.text
        Shared.shared.isAuto = swcAuto.isOn
        
        //Set time
        Shared.shared.StartTime = timePicker.date
        
        //Set Water Needed
        let intWaterNeeded = 1 + presetSeg.selectedSegmentIndex
        Shared.shared.waterNeeded = String(intWaterNeeded) + " Inch/wk"
        
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

