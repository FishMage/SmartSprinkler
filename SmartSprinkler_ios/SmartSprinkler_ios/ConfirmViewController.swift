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
    let addr = "10.0.1.44"
    let port = 9876
    
    //Network variables
    var networkEnable = false
    var inStream : InputStream?
    var outStream: OutputStream?
    
    //Data received
    var buffer = [UInt8](repeating: 0, count: 200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if networkEnable == false{
            NetworkEnable()
            networkEnable = true
        }
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
    
    //NETWORK FUNCTIONS
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
    
    func sendData(input: String) {
        let data : NSData = input.data(using: String.Encoding.utf8)! as NSData
        //outStream?.write(<#T##buffer: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>, maxLength: <#T##Int#>)
        outStream?.write(data.bytes.assumingMemoryBound(to: UInt8.self), maxLength: data.length)
        print("data Sent")
    }
    
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
//            labelConnection.text = "Failed to connect to server"
//            buttonConnect.alpha = 1
//            buttonConnect.enabled = true
//            label.text = ""
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
               // label.text = bufferStr! as String
                print(bufferStr!)
            }
            
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
//        case Stream.Event.:
//            print("None")
        case Stream.Event.openCompleted:
            print("OpenCompleted")
            //labelConnection.text = "Connected to server"
        default:
            print("Unknown")
        }
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
            
            //TODO: Socket Connection
//            if networkEnable == false{
//                NetworkEnable()
//            }
            let data = lblZipcode.text!  + " " + lblStartTime.text! + " " + lblWaterNeeded.text!
            print("Sending: " + data)
            sendData(input: data)
        }
        else{
            if networkEnable == true{
                print("NetworkDisable")
//                inStream?.close()
//                outStream?.close()
                //networkEnable = false
            }
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
