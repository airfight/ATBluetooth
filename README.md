# ATBluetooth
A Library only for iOS
------
1.ATBluetooth一个基于原生CoreBluetooth框架封装的轻量库

2.目前仅支持中心模式

3.项目同时提供block以及代理回传数据方式

4.可无缝接入蓝牙开发

5.项目持续优化完善中

6. test

----

## 使用教程
1. 初始化
```
atBlueTooth = ATBlueToothContext.default
atBlueTooth.confing(.CenteMode)//目前仅支持中心模式
atBlueTooth.delegate = self //设置代理 ATCentralDelegte
atBlueTooth.startScanForDevices(advertisingWithServices: ["FFF0"]) // 扫描特定的服务
atBlueTooth.startScanForDevices() //扫描所有服务

//ATCentralDelegte
func didFoundATBleDevice(_ device: ATBleDevice)

```
2.连接设备 

```
atBlueTooth.connect(device)
device?.delegate = self //设置代理 ATBleDeviceStateDelegate


//ATBleDeviceStateDelegate
func updatedATBleDeviceState(_ state:ATBleDeviceState,error:Error?)
func updatedIfWriteSuccess(_ result:Result<Any>?)
  ```
3.支持重新连接设备
```
//由设备的uuidString  此标志同一设备在不同的手机不同
func reconnectDevice(_ uuidString:String?)
```
5.主工厂 
```
ATBlueToothContext
```
5.详细教程请下载[主分支](https://github.com/airfight/ATBluetooth.git)查看

6.欢迎star issues
