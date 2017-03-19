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
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCompleteMessage.isHidden = true
        lblCompleteMessage_small.isHidden = true
        //lblClickToStart.isHidden = false
       // lblCongrats.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnStartSprinklingOnClick(_ sender: Any) {
        if btnStartSprinkling.titleLabel?.text != "Finish"{
            sleep(1)
            //btnStartSprinkling.isHidden = false
            btnStartSprinkling.setTitle("Finish", for: .normal)
            btnStartSprinkling.backgroundColor = #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
            lblClickToStart.isHidden = true
            lblCompleteMessage_small.isHidden = false
            lblCompleteMessage.isHidden = false
            //lblCongrats.isHidden = false
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
