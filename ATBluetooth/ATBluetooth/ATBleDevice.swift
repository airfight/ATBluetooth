//
//  ATBleDevice.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/10.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/10  下午5:57
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

protocol ATBleDeviceStateDelegate {
    
    func updatedATBleDeviceState(_ state:ATBleDeviceState,error:Error?)
    func updatedIfWriteSuccess(_ result:Result<Any>?)
    
}

class ATBleDevice: NSObject {
    
    var peripheral:CBPeripheral!
    var advertisementData:[String:Any]?
    var rssi:NSNumber?
    public var delegate:ATBleDeviceStateDelegate?
    internal var serviceDelegate:ATCBPeripheralDelegate?
    
    init( _ peripheral:CBPeripheral,advertisementData: [String : Any]?, rssi RSSI: NSNumber?) {

        super.init()
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.rssi = RSSI
        serviceDelegate = ATCBPeripheralDelegate.init(peripheral)

    }
    
    internal func registerPeripheralDelegate() {
        
        peripheral.delegate = serviceDelegate
        
    }
    

}

