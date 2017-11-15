//
//  DeviceCell.swift
//  ATBluetooth
//
//  Created by ZGY on 2017/11/15.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/15  下午5:16
//  GiantForJade:  Efforts to do my best
//  Real developers ship.


import UIKit

class DeviceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    func reloadUI(_ device:ATBleDevice) {
        
        nameLb.text = device.peripheral.name ?? "No name"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
