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
    
    internal var peripheral:CBPeripheral!
    internal var uuid:String?
    internal var advertisementData:[String:Any]?
    internal var rssi:NSNumber?
    internal var configuration:ATConfiguration?
    internal var state:ATBleDeviceState?
    public var delegate:ATBleDeviceStateDelegate?
    internal var serviceDelegate:ATCBPeripheralDelegate?
    
    init( _ peripheral:CBPeripheral,advertisementData: [String : Any]?, rssi RSSI: NSNumber?) {

        super.init()
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        uuid = peripheral.identifier.uuidString
        self.rssi = RSSI
        serviceDelegate = ATCBPeripheralDelegate.init(peripheral)
        analysisAdvertisementData()
    }
    
    internal func writeData(_ data:Data,type:ATCharacteristicWriteType = .withResponse) {
        
        guard configuration != nil else {
            return
        }
        
        peripheral.writeValue(data, for: (configuration?.writeCharacteristic)!,type: (type == .withResponse ? CBCharacteristicWriteType.withResponse : CBCharacteristicWriteType.withoutResponse))
        
    }
    
    internal func analysisAdvertisementData() {
        
        let adva1 = advertisementData?[CBAdvertisementDataLocalNameKey]
        let adva2 = advertisementData?[CBAdvertisementDataManufacturerDataKey]
        let adva3 = advertisementData?[CBAdvertisementDataServiceDataKey]
        let adva4 = advertisementData?[CBAdvertisementDataServiceUUIDsKey]
        let adva5 = advertisementData?[CBAdvertisementDataOverflowServiceUUIDsKey]
        let adva6 = advertisementData?[CBAdvertisementDataTxPowerLevelKey]
        let adva7 = advertisementData?[CBAdvertisementDataIsConnectable].debugDescription
        let adva8 = advertisementData?[CBAdvertisementDataSolicitedServiceUUIDsKey]

//        Print("CBAdvertisementDataLocalNameKey\(adva1)")
//        Print("CBAdvertisementDataManufacturerDataKey\(adva2)")
//        Print("CBAdvertisementDataServiceDataKey\(adva3)")
//        Print("CBAdvertisementDataServiceUUIDsKey\(adva4)")
//        Print("CBAdvertisementDataOverflowServiceUUIDsKey\(adva5)")
//        Print("CBAdvertisementDataTxPowerLevelKey\(adva6)")
//        Print("CBAdvertisementDataIsConnectable\(adva7)")
//        Print("CBAdvertisementDataSolicitedServiceUUIDsKey\(adva8)")
//        Print("CBAdvertisementDataTxPowerLevelKey\(adva1)")
        
    }
    
    override var description: String {
        return "[\(String(describing: rssi ?? 0))db] " + ((advertisementData![CBAdvertisementDataIsConnectable]! as AnyObject).debugDescription == "1" ? "可连接" : "不可连接")
    }
    
    
    internal func registerPeripheralDelegate() {
        
        peripheral.delegate = serviceDelegate
        
    }
    

}

