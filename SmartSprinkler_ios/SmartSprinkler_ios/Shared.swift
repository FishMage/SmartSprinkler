//
//  Shared.swift
//  SmartSprinkler_ios
//
//  Created by Richard Chen on 3/29/17.
//  Copyright © 2017 Richard Chen. All rights reserved.
//

import Foundation

final class Shared{
    static let shared = Shared()
    //From LocationController to FirstViewController
    var zipcode: String!
    
    //Network configuration
    var deviceConnected = false
    var deviceAddr = ""
    
    //From FirstViewController to ConfirmViewController
    var Precipitation: String!
    var confirmedZip: String!
    var waterNeeded: String!
    var StartTime: Date!
    var isAuto: Bool!
    
    //History persistence Storage
    //var historyArr:Array<String>!
    var historyCount = 0
    let userDefaults = UserDefaults.standard
    
    //Device List
    var hasDevice = false
}
