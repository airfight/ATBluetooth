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
//        let options = [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),CBCentralManagerOptionRestoreIdentifierKey:"ATRestoreIdentifier"] as [String:Any]
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    public var isScanning:Bool {
//        set  {
//            return newValue
//        }
//        get {
            return centralManager?.isScanning ?? false
//        }
    }
    
    public func startScanForDevices(advertisingWithServices services: [String]? = nil) {
        
        guard !isScanning else {
            return
        }

        centralManager?.scanForPeripherals(withServices: services?.uuids, options: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationDidEnterBackground() {
        centralManager?.stopScan()
    }
    
    @objc func applicationWillResignActive() {
        // TODO:
    }
    
}

extension ATCentral:CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if #available(iOS 10.0, *) {
            updateCBState(central)
        } else {
            updatecentralManagerState(central.centralManagerState)
        }
        Print(state)
        
        switch state ?? .Unkonwn {
        case .Unkonwn:
            break
        case .Closed:
            break
        default:

//            if !isScanning {
//                centralManager?.scanForPeripherals(withServices: nil, options: nil)
//            }
            startScanForDevices(advertisingWithServices: ["FFF0"])
            break
        }
        
    }
    
    ///discover perheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Print("discover peripheral:------\(peripheral.name ?? "nil")-----")
        
        let device = ATBleDevice.init(peripheral, advertisementData: advertisementData)
        
//        Print("\(device.peripheral),\(device.advertisementData)")
        guard !discoverPeripherals.contains(device) else {
            return
        }
        
        for item in discoverPeripherals {
            Print(item.peripheral)
        }
        
        discoverPeripherals.append(device)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//
//    }
    
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
            state = ATCBState.Opened
        }
        
    }
    
}

extension Collection where Iterator.Element == String {
    var uuids:[CBUUID] {
        return self.map{(CBUUID(string: $0))}
    }
}
