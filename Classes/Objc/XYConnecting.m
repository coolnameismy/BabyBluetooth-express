//
//  XYConnecting.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "XYConnecting.h"



@interface XYConnecting(){
    BabyBluetooth *baby;
}


@property (nonatomic ,copy) XYFilterConnectBlock filterConnectBlock;

@end

@implementation XYConnecting


- (instancetype)init
{
    self = [super init];
    if (self) {
        baby = [BabyBluetooth shareBabyBluetooth];
        //订阅ble事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverPeripheral:) name:BabyNotificationAtDidDiscoverPeripheral object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectPeripheral:) name:BabyNotificationAtDidConnectPeripheral object:nil];
    }
    return self;
}

- (void)dealloc
{
#warning 移除通知订阅
}

- (void)discoverPeripheral:(NSNotification *)notiy{
    
    NSDictionary *data = notiy.object;
    
    //回调
    [self.delegate express:self notificationOn:@"discover" withData:data];
    
    //处理连接
    if(self.filterConnectBlock([data objectForKey:@"peripheral"],[data objectForKey:@"advertisementData"],[data objectForKey:@"RSSI"])){
        [baby.centralManager connectPeripheral:[data objectForKey:@"peripheral"] options:nil];
    }
}

- (void)connectPeripheral:(NSNotification *)notiy{
    
    NSDictionary *data = notiy.object;
    //回调事件
    [self.delegate express:self notificationOn:@"connect" withData:data];
    if (![[data objectForKey:@"error"]isEqualToString:@""]) {
        //连接成功后关闭扫描
        [baby.centralManager stopScan];
    }
}
 
/**
 启动
 1：在有UUID时，首先通过UUID直连设备，如果连接不上则开启扫描，扫描到设备后会连接
 2：连接设备后会扫描和发现设备的全部服务和特征值，会把所有的特征值读取一次
 3：读取设备数据时会先进
 4：全部操作完成会回叫ready方法，开发者可以在ready方法实现自己的逻辑
 */
- (void)connectWithName:(NSString *)nameCondition {
    
    self.filterConnectBlock =  ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
#warning 实现% like匹配
        return [nameCondition isEqualToString:peripheral.name];
    };
    baby.scanForPeripherals().begin();
}

- (void)connectWithBlock:(BOOL (^) (CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI))block {
    self.filterConnectBlock = block;
    baby.scanForPeripherals().begin();
}


- (void)connectWithUUIDString:(NSString *)UUIDString {
    CBPeripheral *p = [baby retrievePeripheralWithUUIDString:UUIDString];
    if (p) {
        baby.having(p).enjoy();
        return;
    }
    
    //如果不能直连，扫描设备后连接
    self.filterConnectBlock = ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
        return [[peripheral.identifier UUIDString] isEqualToString:UUIDString];
    };
    baby.scanForPeripherals().begin();
    
}







@end
