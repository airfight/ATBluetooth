//
//  ViewController.swift
//  ATBluetooth
//
//  Created by macpro on 2017/11/10.
//  Copyright © 2017年 macpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var atBlueTooth:ATBlueTooth!
    var dataArr:[ATBleDevice] = [] {
        
        didSet {
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = view.frame
        atBlueTooth = ATBlueTooth.default
        
        atBlueTooth.atCentral.delegate = self
        atBlueTooth.atCentral.scanBlock = { () in
            
            self.atBlueTooth.atCentral.startScanForDevices()
//            self.atBlueTooth.atCentral.startScanForDevices(advertisingWithServices: ["FFF0"])
            
        }
        
//        dataArr = atBlueTooth.atCentral.discoverPeripherals
//        tableView.backgroundColor = UIColor.red
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        //解决iOS 10.3.1上方留白问题
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.tableFooterView = UIView()
        
//        let device = atBlueTooth.atCentral.discoverPeripherals.filter({$0.peripheral.name == "Ozner Cup"}).last
        
//        let uuid1 = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
//        let uuid2 = UUID(uuidString: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")!
        
//        atBlueTooth.atCentral.configuration = ATConfiguration("FFF2", readServiceCharacteristicUUIDString: "FFF1")
//        atBlueTooth.atCentral.connect(device)
//        device?.delegate = self
        
//        device?.peripheral.writeValue(data1, for: (atBlueTooth.atCentral.configuration?.writeCharacteristic)!, type: CBCharacteristicWriteType.withResponse)
        
//        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCellID") as! DeviceCell
        
        let device = dataArr[indexPath.row]
        
        cell.reloadUI(device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController:ATBleDeviceStateDelegate,ATCentralDelegte {
    
    func didFoundATBleDevice(_ device: ATBleDevice) {
        dataArr.append(device)
    }
    
    
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

