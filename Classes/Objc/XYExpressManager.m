//
//  XYExpressDistributer.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "XYExpressManager.h"
#import "XYExpress.h"

@implementation XYExpressManager



//单例expressList
+ (instancetype)shareExpressManager {
    static XYExpressManager *share;
    if (!share) {
        share = [[XYExpressManager alloc]init];
    }
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBabybluetoothDelegate];
        
    }
    return self;
}

- (XYExpress *)Express: (NSUUID *)uuid {
    for (XYExpress *express in self.list) {
        if (express.thePeripheral.identifier == uuid) {
            return  express;
        }
    }
    return nil;
}

- (void)registerExpress: (XYExpress *)express {
    [self.list addObject:express];
}

- (void)unregisterExpress: (XYExpress *)express {
    if ([self.list containsObject:express]) {
        [self.list removeObject:express];
    }
}
- (void)setBabybluetoothDelegate {
    __weak __typeof(self) weakSelf = self;

    //设置委托
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        
    }];
    
    //设置连接设备的委托
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [weakSelf emit:KCONNECT uuid:peripheral.identifier data:nil error:nil];
    }];
    
    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        [weakSelf emit:KDISCOVERC uuid:peripheral.identifier data:nil error:error];
    }];
    
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        [weakSelf emit:KDISCOVERC uuid:peripheral.identifier data:nil error:error];
    }];

    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        [weakSelf emit:KREADC uuid:peripheral.identifier data:nil error:error];
    }];

    //设置设备断开测委托
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
         [weakSelf emit:KDISCONNECT uuid:peripheral.identifier data:nil error:error];
    }];
    
    //读取数据的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        [weakSelf emit:KREADVALUE uuid:peripheral.identifier data:nil error:error];
    }];
    
    //订阅到数据
    [self.baby setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        [weakSelf emit:KNOTIYVALUE uuid:characteristic.service.peripheral.identifier data:nil error:error];

    }];
}


- (void)emit:(NSString *)type uuid:(NSUUID *)uuid data:(NSDictionary *)data error:(NSError *)error {
    if (error) {
        [[self Express:uuid] error:error type:type];
        return;
    }
    [[self Express:uuid] received:data type:type];
}

@end
