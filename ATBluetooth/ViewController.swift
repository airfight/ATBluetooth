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
//        _ = ATCentral()
        let device = atBlueTooth.atCentral.discoverPeripherals.filter({$0.peripheral.name == "Ozner Cup"}).last
        atBlueTooth.atCentral.connect(device)
        device?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:ATBleDeviceStateDelegate {
    
    func updatedATBleDeviceState(_ state: ATBleDeviceState, error: Error?) {
        Print(state)
    }
    
    
    
    
}

