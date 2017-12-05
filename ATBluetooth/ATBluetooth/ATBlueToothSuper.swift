//
//  ATBlueToothManager.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/30.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/30  下午2:15
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ATBlueToothSuper: NSObject {

    private struct atassociatedKeys {
        static var sigletonKey = "sigletonKey"
    }
    
    public var defalut: ATBlueToothSuper {
        
        struct Sigleton {
            static let instance = ATBlueToothSuper()
        }
        return Sigleton.instance
    }

//    open static var `default`:ATBlueToothSuper {
//
//        var instance = objc_getAssociatedObject(self, &atassociatedKeys.sigletonKey)
//
//        if instance == nil {
//            instance = ATBlueToothSuper()
//            objc_setAssociatedObject(self, &atassociatedKeys.sigletonKey, instance, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        return instance as! ATBlueToothSuper
//    }
    
    var delegate:ATContextDelegate?
    
    //implents
    func startScanForDevices() {
        
    }
    
    func connect(_ device:ATBleDevice?){
        
    }
    
    func disconnectDevice(_ device:ATBleDevice?) {
        
    }
    
    func reconnectDevice(_ uuidString:String?) {
        
    }
}
