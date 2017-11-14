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
    public var discoverPeripherals:[ATBleDevice] = []
    private var connectedPeripherals:[ATBleDevice] = []
    private(set) open var connectedDevice: ATBleDevice?
    
    private lazy var dispatchQueue:DispatchQueue = DispatchQueue(label: "ATBluetooth.kit",attributes:[])
    private lazy var scanThread = Thread.init(target: self, selector: #selector(startScanPeripherals), object: nil)
    
    override init() {
        super.init()
        
        /// alter bluetooth state
//        let options = [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),CBCentralManagerOptionRestoreIdentifierKey:"ATRestoreIdentifier"] as [String:Any]
        
        centralManager = CBCentralManager(delegate: self, queue: dispatchQueue)
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
    
    @objc public func startScanPeripherals() {
        
        guard !isScanning else {
            return
        }
        
//        while 1 == 1 {
        
        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "FFF0")], options: nil)

//        }
        
        
    }
    
    public func connect(_ device:ATBleDevice?) {
        
        guard connectedDevice == nil else {
            return
        }
        
        connectedDevice = device
        guard let peripheral = connectedDevice?.peripheral else {
            return
        }
        
        guard peripheral.state == .disconnected else {
            return
        }
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.Connecting,error:nil)

        centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(value: true)])
        
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
//            scanThread.start()
            break
        }
        
    }
    
    ///discover perheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Print("discover peripheral:------\(peripheral.name ?? "nil")-----")
        // if CBPeripheral name is nil,untreated
        
        let device = ATBleDevice.init(peripheral, advertisementData: advertisementData, rssi: RSSI)
        
        guard !discoverPeripherals.peripherals.contains(device.peripheral) else {
            return
        }
        
        discoverPeripherals.append(device)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        guard let _ = connectedDevice else {
            return
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.ConnectedFailed, error: error)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.Disconnect, error: error)
        
        guard peripheral.identifier.uuidString == connectedDevice?.peripheral.identifier.uuidString else {
            return
        }
        
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

extension Collection where Iterator.Element == ATBleDevice {
    var peripherals:[CBPeripheral] {
        return self.map{$0.peripheral}
    }
}

