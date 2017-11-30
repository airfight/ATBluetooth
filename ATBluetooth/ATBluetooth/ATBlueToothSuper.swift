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

    public var defalut: ATBlueToothSuper {
        
        struct Sigleton {
            static let instance = ATBlueToothSuper()
        }
        return Sigleton.instance
    }
    
}
