//
//  ConfirmViewController.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/11/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import UIKit


class ConfirmViewController: UIViewController,StreamDelegate {
    
    //@IBOutlet weak var lblCongrats: UILabel!
    @IBOutlet weak var lblDeviceId: UILabel!
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
    
    //Socket Server
    var addr = ""
    let port = 9876
    
    //Network variables
    var networkEnable = false
    var inStream : InputStream?
    var outStream: OutputStream?
    
    //Data received
    var buffer = [UInt8](repeating: 0, count: 200)
    
    //Timer 
    var count = 10
    var originalCompleteMessage = ""
    //var timer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Shared.shared.hasDevice{
            lblDeviceId.isHidden = false
        }else{
            lblDeviceId.isHidden = true
        }
        lblCompleteMessage.isHidden = true
        lblCompleteMessage_small.isHidden = true
        originalCompleteMessage = lblCompleteMessage_small.text!
        if (Shared.shared.deviceAddr != ""){
             addr = Shared.shared.deviceAddr
        }
        else{
             addr = "10.140.137.122" //Default private IP
        }
        
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
    
    /*NETWORK FUNCTIONS*/
    
    //Enable a network session using socket connection (Port: 9876)
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
    
    //End current session
    func NetworkDisable(){
        print("EndEncountered")
        //labelConnection.text = "Connection stopped by server"
        inStream?.close()
        inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        outStream?.close()
        print("Stop outStream currentRunLoop")
        outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    //Send data to the RaspberryPi in UInt8 format
    func sendData(input: String) {
        let data : NSData = input.data(using: String.Encoding.utf8)! as NSData
        //outStream?.write(<#T##buffer: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>, maxLength: <#T##Int#>)
        outStream?.write(data.bytes.assumingMemoryBound(to: UInt8.self), maxLength: data.length)
        print("data Sent")
    }
    
    // NOT used, actively close server, only for test purposes
    func btnQuitPressed() {
        let data : NSData = "Quit".data(using: String.Encoding.utf8)! as NSData
        outStream?.write(data.bytes.assumingMemoryBound(to: UInt8.self), maxLength: data.length)
    }
    
    func stream(aStream: Stream, handleEvent eventCode: Stream.Event) {
        
        switch eventCode {
        case Stream.Event.endEncountered:
            print("EndEncountered")
            //labelConnection.text = "Connection stopped by server"
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            //buttonConnect.alpha = 1
        //buttonConnect.enabled = true
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
            
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                print(bufferStr!)
            }
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
        case Stream.Event.openCompleted:
            print("OpenCompleted")
        //labelConnection.text = "Connected to server"
        default:
            print("Unknown")
        }
    }
    //Coundown updater
    func update(){
        if count > 0 {
            count -= 1
            lblCompleteMessage_small.text = "Auto Mode: Sprinkler will start in \(count) seconds "
        }
        if count == 0 {
            lblCompleteMessage_small.text = originalCompleteMessage
        }
    }
    
    @IBAction func btnStartSprinklingOnClick(_ sender: Any) {
        if btnStartSprinkling.titleLabel?.text != "Finish"{
            sleep(1)
            //Display countdown if Auto
            if Shared.shared.isAuto{
                lblCompleteMessage_small.text = "Connecting..."
              _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ConfirmViewController.update), userInfo: nil, repeats: true)
            }
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
        
            let data = lblZipcode.text!  + " " + lblStartTime.text! + " " + lblWaterNeeded.text!
            print("Sending: " + data)
            NetworkEnable()
            sendData(input: data)
            
        }
        else{
            if networkEnable == true{
                print("NetworkDisable")
            }
            self.performSegue(withIdentifier: "segueToMain", sender: self)
        }
    
    }
    
}
