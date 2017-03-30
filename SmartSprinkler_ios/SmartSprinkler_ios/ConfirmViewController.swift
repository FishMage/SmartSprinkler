//
//  ConfirmViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/11/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit


class ConfirmViewController: UIViewController {

    //@IBOutlet weak var lblCongrats: UILabel!
    @IBOutlet weak var lblClickToStart: UILabel!
    @IBOutlet weak var lblCompleteMessage_small: UILabel!
    @IBOutlet weak var btnStartSprinkling: UIButton!
    @IBOutlet weak var lblCompleteMessage: UILabel!
    
    //User defined values:
    @IBOutlet weak var lblPrecipitation: UILabel!
    @IBOutlet weak var lblZipcode: UILabel!
    @IBOutlet weak var lblWaterNeeded: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblAuto: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCompleteMessage.isHidden = true
        lblCompleteMessage_small.isHidden = true
        
        //Get info from previous View
        if (Shared.shared.confirmedZip) != nil {lblZipcode.text = Shared.shared.confirmedZip}
        if (Shared.shared.isAuto) != nil {
            if Shared.shared.isAuto == true
            {
                lblAuto.text = "ON"
            }else{
                lblAuto.text = "OFF"
            }
        }
        if (Shared.shared.Precipitation) != nil {}
        if (Shared.shared.StartTime) != nil {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            let now = dateformatter.string(from: Shared.shared.StartTime)
            lblStartTime.text = now
            let end = dateformatter.string(from: Shared.shared.StartTime.addingTimeInterval(7*24*60*60))
            lblEndTime.text = end
        }
        if (Shared.shared.waterNeeded) != nil {
            lblWaterNeeded.text = Shared.shared.waterNeeded
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnStartSprinklingOnClick(_ sender: Any) {
        if btnStartSprinkling.titleLabel?.text != "Finish"{
            sleep(2)
            //btnStartSprinkling.isHidden = false
            btnStartSprinkling.setTitle("Finish", for: .normal)
            btnStartSprinkling.backgroundColor = #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
            lblClickToStart.isHidden = true
            lblCompleteMessage_small.isHidden = false
            lblCompleteMessage.isHidden = false
            let historyArr = [lblZipcode.text, lblStartTime.text]
            
            //TODO: Persistent Storage for History
            let numHistory = String(Shared.shared.historyCount)
            Shared.shared.userDefaults.set(historyArr, forKey: numHistory)
            Shared.shared.userDefaults.synchronize()
            Shared.shared.historyCount += 1
            print("Number of History: " + String(Shared.shared.historyCount))
            
            //TODO: AWS IoT...
            
        }
        else{
            self.performSegue(withIdentifier: "segueToMain", sender: self)
        }
        
        
        
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
