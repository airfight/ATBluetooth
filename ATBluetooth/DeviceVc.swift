//
//  DeviceVc.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/16.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/16  下午2:37
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class DeviceVc: UIViewController {
    
    //MARK: - Attributes
    var device: ATBleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Print(device?.state)
        
    }
    //MARK: - Override
    
    
    //MARK: - Initial Methods
    
    
    //MARK: - Delegate
    
    
    //MARK: - Target Methods
    
    @IBAction func sendAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 666:
//            let data = Data.init(bytes: [0x12])
          let data = Data.init(bytes: [0x82])
            
//            device?.writeData(data)
          ATBlueToothContext.default.writeData(data, type: ATCharacteristicWriteType.withResponse, block: { (result) in
            
            
          })
            break
        case 777:
             ATBlueToothContext.default.disconnectDevice()
            break
        case 888:
            ATBlueToothContext.default.reconnectDevice(device?.uuid)
            break
        default:
            break
        }
  
        
    }
    
    //MARK: - Notification Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    
    //MARK: - Privater Methods
    
    
    //MARK: - Setter Getter Methods
    
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ATBlueToothContext.default.connect(device)
        self.title = device?.state?.description
        device?.delegate = self
//        updatedATBleDeviceState((device?.state)!, error: nil)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeviceVc:ATBleDeviceStateDelegate {
    
    func updatedIfWriteSuccess(_ result: Result<Any>?) {
        
        guard result != nil else {
            return
        }
        
        switch result! {
        case .Success(let value):
//            print(String.init(data: value!, encoding: String.Encoding.ascii))
//            Print(String.init(data: value!, encoding: String.Encoding.utf8))
            Print(value)
        case .Failure(let error):
            Print(error)
        }
        
    }
    
    func updatedATBleDeviceState(_ state: ATBleDeviceState, error: Error?) {
        
        DispatchQueue.main.async {
            
            self.title = "\(state.description)"
            
            Print(state.description)
            
        }
        
    }
    
}
