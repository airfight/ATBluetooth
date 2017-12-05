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



typealias bleStartScan = () -> Void

class ATCentral: NSObject {
    
    public var centralManager:CBCentralManager?
    public var state:ATCBState?
    public var delegate:ATCentralDelegte?
    public var discoverPeripherals:[ATBleDevice] = []
    private var connectedPeripherals:[ATBleDevice] = []
    private(set) open var connectedDevice: ATBleDevice?
    internal var configuration:ATConfiguration?
    internal var scanBlock:bleStartScan?
    
    private lazy var dispatchQueue:DispatchQueue = DispatchQueue(label: "ATBluetooth.kit",attributes:[])
    private lazy var scanThread = Thread.init(target: self, selector: #selector(startScanPeripherals), object: nil)
    
    override init() {
        super.init()
        
        /// alter bluetooth state
        let options = [CBCentralManagerOptionShowPowerAlertKey:NSNumber.init(value: true),CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber.init(value: false)] as [String:Any]
        
        centralManager = CBCentralManager(delegate: self, queue: dispatchQueue,options:options)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    public var isScanning:Bool { return centralManager?.isScanning ?? false }
    
    public func startScanForDevices(advertisingWithServices services: [String]? = nil) {
        
        guard !isScanning else {
            return
        }

        centralManager?.scanForPeripherals(withServices: services?.uuids, options: nil)
        
    }
    
    public func stopScan() {
        
        centralManager?.stopScan()
    }
    
    public func getPerperh() {
        
        let perhial = centralManager?.retrievePeripherals(withIdentifiers: [UUID(uuidString: "")!])
        
    }
    
  
    
    @objc public func startScanPeripherals() {
        
        guard !isScanning else {
            return
        }
        
        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "FFF0")], options: nil)
        
    }
    
    public func connect(_ device:ATBleDevice?) {
        
        guard (connectedDevice?.peripheral != device?.peripheral || (device?.peripheral.state != .connected)) else {
            return
        }
        
        if let oldDevice = connectedDevice {
            
            centralManager?.cancelPeripheralConnection(oldDevice.peripheral)
        }
        
        connectedDevice = device
        connectedDevice?.configuration = configuration
        guard let peripheral = connectedDevice?.peripheral else {
            return
        }
        
        guard peripheral.state == .disconnected else {
            return
        }
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.Connecting,error:nil)

        centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(value: false)])
        
    }
    
    public func disconnectDevice() {
        
        guard let device = connectedDevice else {
            return
        }
        
        if device.peripheral.state != .connected  {
            return
        }
        
        centralManager?.cancelPeripheralConnection(device.peripheral)
        
        device.delegate?.updatedATBleDeviceState(.Disconnect, error: nil)
        
    }
    
    public func reconnectDevice(_ uuidString:String?) {

        guard uuidString != nil else {
            assert(true, "reconnectDevice uuidString cannot be nil")
            return
        }
        
        let periPherals = centralManager?.retrievePeripherals(withIdentifiers: [UUID(uuidString: uuidString!)!])
        
        if let periPheralArr = periPherals {
            
            guard periPheralArr.count > 0  else {
                assert(true, "reconnectDevice cannot find periPherals")
                return
            }
            
            guard periPheralArr.first?.state ==  CBPeripheralState.disconnected else {
                Print(periPheralArr.first?.state)
                Print("isConnecting or Connected")
                return
            }
            
            centralManager?.connect(periPheralArr.first!, options: nil)
            
        }
        
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
//            startScanForDevices()
            scanBlock?()
            break
        }
        
    }
    
    ///discover perheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Print("discover peripheral:------\(peripheral.name ?? "nil")-----")
        Print("advertisementData\(advertisementData.description)")
        // if CBPeripheral name is nil,untreated
        let device = ATBleDevice.init(peripheral, advertisementData: advertisementData, rssi: RSSI)
        
        guard !discoverPeripherals.uuidStrings.contains(device.peripheral.identifier.uuidString) else {
            return
        }
        
        discoverPeripherals.append(device)
        DispatchQueue.main.async {
            
            self.delegate?.didFoundATBleDevice(device)

        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        guard let device = connectedDevice else {
            return
        }

        device.peripheral.delegate = self
        device.peripheral.discoverServices(nil)
//        [peripheral discoverServices:@[[CBUUID UUIDWithString:@"180A"]]];
        
//        device.peripheral.discoverServices([CBUUID(string: "180A")])

        device.delegate?.updatedATBleDeviceState(.Connected, error: nil)
        
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.ConnectFailed, error: error)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        connectedDevice?.delegate?.updatedATBleDeviceState(.Disconnect, error: error)
        
        guard peripheral.identifier.uuidString == connectedDevice?.peripheral.identifier.uuidString else {
            return
        }
        
//        centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(value: true)])
//        connect(connectedDevice)
        
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


extension ATCentral:CBPeripheralDelegate {
    
    //MARK - CBPeripheralDelegate
    
    internal func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    //MARK: - Discovering Services
    ///Invoked when you discover the peripheral’s available services.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            return
        }
        
//        peripheral.discoverCharacteristics([CBUUID(string: "0x2A23")], for: <#T##CBService#>)
        
        for service in services {
            
            if service.characteristics != nil {
                
                self.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: nil)
                
            } else {
                
                peripheral.discoverCharacteristics(nil, for: service)
//                peripheral.discoverCharacteristics([CBUUID(string: "180A")], for: service)
                
            }
            
        }
        
    }
    
    ///Invoked when you discover the included services of a specified service.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    //MARK: - Discovering Characteristics and Characteristic Descriptors
    
    ///Invoked when you discover the characteristics of a specified service.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        Print("service.characteristics\(service.characteristics?.count)")
        
        guard service.characteristics != nil else {
            
            return
        }
        
        for item: CBCharacteristic in service.characteristics! {
            
            Print(item)
            //readCharacteristics
            if item.uuid.uuidString == configuration?.readServiceCharacteristicUUIDString {
                
                peripheral.readValue(for: item)
                configuration?.readCharacteristic = item
                peripheral.setNotifyValue(true, for: item)
                
            }
            
            //writeCharacteristics
            if item.uuid.uuidString == configuration?.writeServiceUUIDString {
                configuration?.writeCharacteristic = item
            }
            
        }

//        guard service.uuid == configuration?.dataServiceUUID,let dataCharacteristic = service.characteristics?.filter({$0.uuid == configuration?.dataServiceCharacteristicUUID}).last else {
//            return
//        }
//
//        peripheral.setNotifyValue(true, for: dataCharacteristic)
        
        
    }
    
    ///Invoked when you discover the descriptors of a specified characteristic.
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        
        
    }
    
    //MARK: - Retrieving Characteristic and Characteristic Descriptor Values
    
    ///Invoked when you retrieve a specified characteristic’s value, or when the peripheral device notifies your app that the characteristic’s value has changed.
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
//        guard characteristic.uuid == configuration?.dataServiceCharacteristicUUID else {
//            return
//        }
//
        guard error == nil else {
            connectedDevice?.delegate?.updatedIfWriteSuccess(Result.Failure(error!))
            return
        }
        
        connectedDevice?.delegate?.updatedIfWriteSuccess(Result.Success(characteristic.value))
        
    }
    
    ///Invoked when you retrieve a specified characteristic descriptor’s value.
    internal func  peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
      
        Print("\(descriptor.uuid),\(String(describing: descriptor.value))")
        
    }
    
    //MARK: - Writing Characteristic and Characteristic Descriptor Values
    
    ///Invoked when you write data to a characteristic’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            connectedDevice?.delegate?.updatedIfWriteSuccess(Result.Failure(error!))
        }
        
    }
    
    ///Invoked when you write data to a characteristic descriptor’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    //MARK: - Managing Notifications for a Characteristic’s Value
    
    ///Invoked when the peripheral receives a request to start or stop providing notifications for a specified characteristic’s value.
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    
}

extension Collection where Iterator.Element == String {
    var uuids:[CBUUID] {
        return self.map{(CBUUID(string: $0))}
    }
}

extension Collection where Iterator.Element == ATBleDevice {
    var uuidStrings:[String] {
        return self.map{$0.peripheral.identifier.uuidString}
    }
}

