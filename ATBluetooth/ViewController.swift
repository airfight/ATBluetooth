//
//  ViewController.swift
//  ATBluetooth
//
//  Created by macpro on 2017/11/10.
//  Copyright © 2017年 macpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let atBlueTooth = ATBlueTooth.default
        sleep(5)
        
        let device = atBlueTooth.atCentral.discoverPeripherals.filter({$0.peripheral.name == "Ozner Cup"}).last
        
//        let uuid1 = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
//        let uuid2 = UUID(uuidString: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")!
        
        atBlueTooth.atCentral.configuration = ATConfiguration("FFF2", readServiceCharacteristicUUIDString: "FFF1")
        atBlueTooth.atCentral.connect(device)
        device?.delegate = self
        
        sleep(5)

        let data1 = Data.init(bytes: [0x12])
        device?.writeData(data1, type: ATCharacteristicWriteType.withResponse)

//        device?.peripheral.writeValue(data1, for: (atBlueTooth.atCentral.configuration?.writeCharacteristic)!, type: CBCharacteristicWriteType.withResponse)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:ATBleDeviceStateDelegate {
    
    func updatedIfWriteSuccess(_ result: Result<Any>?) {
        
        guard result != nil else {
            return
        }
        
        switch result! {
        case .Success(let value):
            Print(value)
        case .Failure(let error):
            Print(error)
        }
        
    }
    
    func updatedATBleDeviceState(_ state: ATBleDeviceState, error: Error?) {
        Print(state)
    }
    
    
    
    
}

