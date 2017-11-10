//
//  Result.swift
//  GYBluetooth
//
//  Created by ZGY on 2017/10/19.
//Copyright © 2017年 GYJade. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/10/19  上午10:10
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import Foundation

public enum Result<Value> {
    
    case Success(Value)
    case Failure(Error)
    
    /// if success
    public var isSuccess:Bool {
        
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
        
    }
    
    public var value:Value? {
        
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
    
    public var error:Error? {
        
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
    
}

extension Result:CustomStringConvertible,CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .Success:
            return "SUCCESS"
        case .Failure:
            return "FAILURE"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .Success:
            return "SUCCESS: \(String(describing: value))"
        case .Failure:
            return "FAILURE: \(error ?? ATCBError.UnknownError)"
        }
    }
    
}
