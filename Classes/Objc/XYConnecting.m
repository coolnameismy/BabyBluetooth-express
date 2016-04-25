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


@property (nonatomic ,copy) XYFilterBlock filterBlock;
@property (nonatomic ,strong) NSMutableArray *peripherals;

@end

@implementation XYConnecting


- (instancetype)init
{
    self = [super init];
    if (self) {
        baby = [BabyBluetooth shareBabyBluetooth];
        self.peripherals = [[NSMutableArray alloc]init];
        //订阅ble事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverPeripheral:) name:BabyNotificationAtDidDiscoverPeripheral object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectPeripheral:) name:BabyNotificationAtDidConnectPeripheral object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateValueForCharacteristic:) name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
    }
    return self;
}

- (void)dealloc
{
#warning 移除通知订阅
}


//获取已连接的设备
- (NSArray *)connectedPeripheral {
    __block NSMutableArray *connected = nil;
    [self.peripherals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CBPeripheral *p = _peripherals[idx];
        if (p.state & CBPeripheralStateConnected) {
            [connected addObject:p];
        }
    }];
    return connected;
}

- (BOOL)filterForScanfor:(NSDictionary *)data {
//
    return self.filterBlock([data objectForKey:@"peripheral"],[data objectForKey:@"advertisementData"],[data objectForKey:@"RSSI"]);
}
- (void)discoverPeripheral:(NSNotification *)notiy{
    
    //过滤符合条件的外设，才会参数数据回调
    if([self filterForScanfor:notiy.object]){
        //缓存目标对象
        CBPeripheral *p = [notiy.object objectForKey:@"peripheral"];
        if (![self.peripherals containsObject:p]) { [self.peripherals addObject:p];}
        //回调扫描事件
        [self.delegate express:self notificationOn:@"discover" withData:notiy.object];
        //开始连接设备
        baby.having(p).enjoy();
        //连接成功后关闭扫描
        [baby.centralManager stopScan];
//        [baby.centralManager connectPeripheral:[notiy.object objectForKey:@"peripheral"] options:nil];
    }
}

- (void)connectPeripheral:(NSNotification *)notiy{
    //找到目标设备
    CBPeripheral *p = [notiy.object objectForKey:@"peripheral"];
    if(p && [self.peripherals containsObject:p]) {
        if (![[notiy.object objectForKey:@"error"]isEqualToString:@""]) {
          
            //回调事件
            [self.delegate express:self notificationOn:@"connect" withData:notiy.object];
        }
    }

}

- (void)updateValueForCharacteristic:(NSNotification *)notiy {
    CBPeripheral *p = [notiy.object objectForKey:@"peripheral"];
    CBCharacteristic *c = [notiy.object objectForKey:@"characteristic"];
    if ([[self connectedPeripheral] containsObject:p] ) {
        //回调
        NSDictionary *data = [self.delegate express:self parseDataOnCharacteristic:[c.UUID UUIDString] withData:c.value];
        [self.delegate express:self onRecivedData:data];
    }
}
 
/**
 
 1：在有UUID时，首先通过UUID直连设备，如果连接不上则开启扫描，扫描到设备后会连接
 2：连接设备后会扫描和发现设备的全部服务和特征值，会把所有的特征值读取一次
 3：读取设备数据时会先进
 4：全部操作完成会回叫ready方法，开发者可以在ready方法实现自己的逻辑
 */
- (void)connectWithName:(NSString *)nameCondition {
    
    self.filterBlock =  ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
#warning 实现% like匹配
        return [nameCondition isEqualToString:peripheral.name];
    };
    baby.scanForPeripherals().begin();
}

- (void)connectWithBlock:(BOOL (^) (CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI))block {
    self.filterBlock = block;
    baby.scanForPeripherals().begin();
}


- (void)connectWithUUIDString:(NSString *)UUIDString {
    CBPeripheral *p = [baby retrievePeripheralWithUUIDString:UUIDString];
    if (p) {
        self.peripherals = [[NSMutableArray alloc]init];
        [self.peripherals addObject:p];
        baby.having(p).enjoy();
        return;
    }
    
    //如果不能直连，扫描设备后连接
    self.filterBlock = ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
        return [[peripheral.identifier UUIDString] isEqualToString:UUIDString];
    };
    baby.scanForPeripherals().begin();
    
}







@end
