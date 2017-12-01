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
    
    var atBlueTooth:ATBlueToothContext!
    var currentDevice:ATBleDevice?
    var dataArr:[ATBleDevice] = [] {
        
        didSet {
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        atBlueTooth = ATBlueTooth.default
//
//        atBlueTooth.centerManangerDelegate = self
//        atBlueTooth.startScanForDevices()
        
        atBlueTooth = ATBlueToothContext.default
//        atBlueTooth.confing(.CenteMode)
//        atBlueTooth = ATBlueToothContext.shareInstance(PeripheralMode.CenteMode)
        atBlueTooth.delegate = self
        atBlueTooth.startScanForDevices()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        //解决iOS 10.3.1上方留白问题 iOS 7.0问题
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            atBlueTooth.disconnectDevice()
            currentDevice = dataArr[indexPath.row]
            self.performSegue(withIdentifier: "devicePushId", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController:ATCentralDelegte {

    
    func didFoundATBleDevice(_ device: ATBleDevice) {
        dataArr.append(device)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "devicePushId":
            let vc = segue.destination as! DeviceVc
            vc.device = currentDevice
            break
        default:
            break
        }
    }
    
}

