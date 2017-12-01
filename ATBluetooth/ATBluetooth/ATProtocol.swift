//
//  ATProtocol.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/12/1.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/12/1  下午5:46
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

// MARK: - BASE
public protocol ATContextDelegate {
    
}

protocol ATCentralDelegte:ATContextDelegate {
    func didFoundATBleDevice(_ device:ATBleDevice)
}

protocol ATBleDeviceStateDelegate {
    
    func updatedATBleDeviceState(_ state:ATBleDeviceState,error:Error?)
    func updatedIfWriteSuccess(_ result:Result<Any>?)
    
}
