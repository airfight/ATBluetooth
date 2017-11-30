//
//  ATBlueTooth.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/13.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/13  下午4:27
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ATBlueTooth: ATBlueToothSuper {
    
    private var atCentral:ATCentral!
    public var centerManangerDelegate:ATCentralDelegte? {
        
        didSet {
            atCentral.delegate = centerManangerDelegate
        }
        
    }
    
    open static let `default`: ATBlueTooth = {
        
        return ATBlueTooth()
    }()
    
    override init() {
        super.init()
        atCentral = ATCentral()
    }
    
    func startScanForDevices() {
        
        atCentral.scanBlock = { [weak self]() in
            
           self?.atCentral.startScanForDevices()
            
        }

    }
    
    func connect(_ device:ATBleDevice?) {
     
        atCentral.connect(device)
    }
    
    
    
    

}
