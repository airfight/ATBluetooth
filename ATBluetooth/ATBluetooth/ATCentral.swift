//
//  ATCentral.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/10.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/10  下午5:21
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

class ATCentral: NSObject {
    
    public var centralManager:CBCentralManager?
    public var state:ATCBState?
    private var discoverPeripherals:[ATBleDevice] = []
    private var connectedPeripherals:[ATBleDevice] = []
    
    override init() {
        super.init()
        
        /// alter bluetooth state
        let options = [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),CBCentralManagerOptionRestoreIdentifierKey:"ATRestoreIdentifier"] as [String:Any]
        
        centralManager = CBCentralManager(delegate: self, queue: nil,options:options)
        
    }
    
}

extension ATCentral:CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if #available(iOS 10.0, *) {
            updateCBState(central)
        } else {
            updatecentralManagerState(central.centralManagerState)
        }
        
        switch state ?? .Unkonwn {
        case .Unkonwn:
            break
        case .Closed:
            break
        default:
            
            break
        }
        
    }
    
    ///discover perheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Print("discover peripheral:------\(peripheral.name ?? "nil")-----")
        
        let device = ATBleDevice.init(peripheral, advertisementData: advertisementData, rssi: RSSI)
        guard !discoverPeripherals.contains(device) else {
            return
        }
        discoverPeripherals.append(device)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        
        
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    fileprivate func updateCBState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown,.resetting:
            state = ATCBState.Unkonwn
            break
        case .unsupported,.unauthorized,.poweredOff:
            state = ATCBState.Closed
            break
        case .poweredOn:
            //do SomeThing
            state = ATCBState.Opened
        }
    }
    
    fileprivate func updatecentralManagerState(_ centralManagerState: CBCentralManagerState) {
        
        switch centralManagerState {
        case .unknown,.resetting:
            state = ATCBState.Unkonwn
            break
        case .unsupported,.unauthorized,.poweredOff:
            state = ATCBState.Closed
            break
        case .poweredOn:
            //do SomeThing
            state = ATCBState.Opened
        }
    }
    
}
