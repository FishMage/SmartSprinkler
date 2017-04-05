//
//  ConnectionController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/10/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController,StreamDelegate {

    //Alerts
    let alert = UIAlertController(title: "AWS IoT", message: "Device ID: SmrtSprinkler_UWiot found!", preferredStyle: UIAlertControllerStyle.alert)
    let disConnectAlert = UIAlertController(title: "AWS IoT", message: "Device ID: SmrtSprinkler_UWiot Disconnect!", preferredStyle: UIAlertControllerStyle.alert)
    let noDeviceAlert = UIAlertController(title: "AWS IoT", message: "Please provide a device address to connect", preferredStyle: UIAlertControllerStyle.alert)

    //View components
    @IBOutlet weak var lblDeviceAddr: UILabel!
    @IBOutlet weak var txtDeviceAddr: UITextField!
    @IBOutlet weak var lblDeviceId: UILabel!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var processBar: UIProgressView!
    @IBOutlet weak var btnConnection: UIButton!
    
    //Socket Server
    let addr = "10.0.1.44"
    let port = 9876
    
    //Network variables
    var networkEnable = false
    var inStream : InputStream?
    var outStream: OutputStream?
    
    //Data received
    var buffer = [UInt8](repeating: 0, count: 200)
    
    //var progessComplete:Bool!
    var progessComplete = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        processBar.progress = 0.00
        txtDeviceAddr.placeholder = "e.g. 10.0.1.44"
        
        //NOT CONNECTED
        if(Shared.shared.hasDevice == false){
            print("No devices connected")
            btnComplete.isHidden = true
            btnConnection.isEnabled = true
            lblDeviceId.isHidden = true
            processBar.isHidden = true
        }
        //CONNECTED
        else if(Shared.shared.hasDevice == true) {
            print("Has devices connected")
            lblDeviceAddr.isHidden = true
            txtDeviceAddr.isHidden = true
            btnConnection.setTitle("AWS Connected!", for: .normal)
            btnConnection.backgroundColor =  #colorLiteral(red: 0.4767096639, green: 0.7372747064, blue: 0.09030196816, alpha: 1)
            btnConnection.isEnabled = false
            btnComplete.setTitle("Disconnect", for: .normal)
            btnComplete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            processBar.isHidden = true
            lblDeviceId.isHidden = false
        }
    }
    
    //Not used in Expo Version
    func NetworkEnable() {
        print("NetworkEnable")
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = self
        outStream?.delegate = self
        
        inStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        inStream?.open()
        outStream?.open()
        
        buffer = [UInt8](repeating: 0, count: 200)
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
    
    func showDisconnect(){
        disConnectAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        self.present(disConnectAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnCompleteOnClick(_ sender: Any) {
        if (Shared.shared.hasDevice == true){
            //Disconnect 
            print("has Device set false")
            Shared.shared.hasDevice = false
            
        }else{
            print("has Deviceset true")
            Shared.shared.hasDevice = true
        }
    }
    
    @IBAction func btnConnectionOnClick(_ sender: Any) {
        //func updateProgress(){}
        //let progressComplete = false
        if (!Shared.shared.hasDevice && txtDeviceAddr.text == "") {
            //Warning message
            noDeviceAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
            self.present(noDeviceAlert, animated: true, completion: nil)
            self.view.endEditing(true)
        }else{
            processBar.isHidden = false
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                // do whatever you want when the animation is completed
                self.showComplete()
            })
            processBar.setProgress(3, animated: true)
            CATransaction.commit()
            //Shared.shared.hasDevice = true
            if networkEnable == false{
                // NetworkEnable()
                print("Network Enabled")
            }
            //TODO: InputValidation. Send and check message received
            
            Shared.shared.deviceAddr = txtDeviceAddr.text!
            self.view.endEditing(true)
            print("Connection initialized, addr: " + String(Shared.shared.deviceAddr))
        }
    }
  }
