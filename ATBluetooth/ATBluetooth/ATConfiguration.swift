//
//  ATConfiguration.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/14.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/14  下午5:20
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import Foundation
import CoreBluetooth

public class ATConfiguration {

    public let writeServiceUUIDString: String
    
    public let readServiceCharacteristicUUIDString: String
    
    public var writeCharacteristic:CBCharacteristic?
    public var readCharacteristic:CBCharacteristic?
    
    
    public init(_ writeServiceUUIDString: String, readServiceCharacteristicUUIDString: String) {
        
        self.writeServiceUUIDString = writeServiceUUIDString
        self.readServiceCharacteristicUUIDString = readServiceCharacteristicUUIDString
    }
    
//    internal func characteristicUUIDsForServiceUUID(_ serviceUUID: CBUUID) -> [CBUUID] {
//        if serviceUUID == dataServiceUUID {
//            return [ dataServiceCharacteristicUUID ]
//        }
//        return []
//    }

    
}
