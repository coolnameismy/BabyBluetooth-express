//
//  XYPairing.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "XYPairing.h"

@implementation XYPairing


//开启配对
- (void)start:(void (^)(CBPeripheral *CBPeripheral,NSDictionary *advertisementData,NSNumber *RSSI,NSString *MAC))receivedAdvertisement{
    [BabyBluetooth shareBabyBluetooth].scanForPeripherals().begin();
    //订阅扫描事件，回调
    
}

//配对成功，关闭配对
- (void)done{
    [[BabyBluetooth shareBabyBluetooth] cancelScan];
}


@end
