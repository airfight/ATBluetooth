//
//  GYBluetoothConst.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/3/13.
//  Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/3/13  15:42
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import CoreBluetooth

/// 是否输出打印

let IFLOG = 1

public func Print<T>(_ message: T,file: String = #file,method: String = #function, line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

public enum ATCBError:Error {
    case UnknownError
    
    var descrption:String {
        switch self {
        case .UnknownError:
            return "UnknowError"
        }
    }
}


/// CB State
///
/// - Open:
/// - Closed:
/// - Unkonwn:  
public enum ATCBState {
    
    case Opened
    case Closed
    case Unkonwn
    
}

extension CBCentralManager {
    
    internal var centralManagerState: CBCentralManagerState {
        get {
            return CBCentralManagerState(rawValue: state.rawValue) ?? .unknown
        }
    }
    
}

class ATConst: NSObject {

}
