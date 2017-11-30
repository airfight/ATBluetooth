//
//  ATBlueToothContext.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/30.
//  Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/30  下午4:09
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ATBlueToothContext: NSObject {
    
    private var atsuper:ATBlueToothSuper!
    
    var delegate:ATContextDelegate? {
        didSet {
            atsuper.delegate = delegate
        }
    }
    
    init(_ mode:PeripheralMode) {
        super.init()
        switch mode {
            
        case .CenteMode:
            atsuper = ATBlueTooth.default
            break
            
        case .PeripheralMode:
            atsuper = ATBlueTooth.default
            break
        }
    }
    
    func startScanForDevices() {
        atsuper.startScanForDevices()
    }
  
}
