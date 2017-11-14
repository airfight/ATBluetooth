//
//  ATCentralManager.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/13.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/13  下午2:58
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

class ATCBPeripheralDelegate: NSObject,CBPeripheralDelegate {
    
    private(set) var peripheral: CBPeripheral?
    
    internal var configuration:ATConfiguration?
    
    init(_ peripheral:CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        
    }
    
    //MARK - CBPeripheralDelegate
    
    internal func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    //MARK: - Discovering Services
    ///Invoked when you discover the peripheral’s available services.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            
            if service.characteristics != nil {
                
                self.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: nil)
                
            } else {
            peripheral.discoverCharacteristics(configuration?.characteristicUUIDsForServiceUUID(service.uuid), for: service)
                
            }
            
        }
        
    }
    
    ///Invoked when you discover the included services of a specified service.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    //MARK: - Discovering Characteristics and Characteristic Descriptors
    
    ///Invoked when you discover the characteristics of a specified service.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        
        guard service.uuid == configuration?.dataServiceUUID,let dataCharacteristic = service.characteristics?.filter({$0.uuid == configuration?.dataServiceCharacteristicUUID}).last else {
            return
        }
        
        peripheral.setNotifyValue(true, for: dataCharacteristic)
        
        
    }
    
    ///Invoked when you discover the descriptors of a specified characteristic.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        
        
    }
    
    //MARK: - Retrieving Characteristic and Characteristic Descriptor Values
   
    ///Invoked when you retrieve a specified characteristic’s value, or when the peripheral device notifies your app that the characteristic’s value has changed.
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard characteristic.uuid == configuration?.dataServiceCharacteristicUUID else {
            return
        }
        
        Print(characteristic.value)
        
    }
    
    ///Invoked when you retrieve a specified characteristic descriptor’s value.
    internal func  peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
        Print("\(descriptor.uuid),\(descriptor.value)")
        
    }
    
    //MARK: - Writing Characteristic and Characteristic Descriptor Values
    
    ///Invoked when you write data to a characteristic’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    ///Invoked when you write data to a characteristic descriptor’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    //MARK: - Managing Notifications for a Characteristic’s Value
    
    ///Invoked when the peripheral receives a request to start or stop providing notifications for a specified characteristic’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    


    
    
    
}
