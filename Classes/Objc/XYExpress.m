//
//  BabyBluetooth-express.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "XYExpress.h"
#import "BabyBluetooth.h"





@interface XYExpress(){
    
    BabyBluetooth *baby;
    NSString *thisExpressChannel;
}

@property (nonatomic , copy) XYUpdateStateBlock updateStateBlock;
@property (nonatomic , copy) XYFilterDiscoverBlock filterDiscoverBlock;
@property (nonatomic , copy) XYOnReadyBlock onReadyBlock;


@end

@implementation XYExpress




- (instancetype)init
{
    self = [super init];
    if (self) {
        baby = [BabyBluetooth shareBabyBluetooth];
        [self setCommonDelegate];
        thisExpressChannel = [[NSUUID UUID]UUIDString];
    }
    return self;
}

- (void)dealloc {
    
}



- (void)setCommonDelegate {
    __weak __typeof(self) weakSelf = self;
    
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    rhythm.beatsInterval = 1;
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        [bry beatsOver];
        //回调ready方法
        weakSelf.onReadyBlock(self.thePeripheral);
    }];
    
    //设置委托
    [baby setBlockOnCentralManagerDidUpdateStateAtChannel:thisExpressChannel block:^(CBCentralManager *central) {
        weakSelf.updateStateBlock(central.state == CBCentralManagerStatePoweredOn);
    }];
    
    //设置连接设备的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        weakSelf.thePeripheral = peripheral;
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
         [rhythm beats];
         
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
       [rhythm beats];
        
    }];
    
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
        
    }];
    
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
        
    }];
    
    //断开设备测

}


/**
 从扫描开始启动
 */

- (void)startFromScanWithName:(NSString *)name{
    
    [baby setFilterOnConnectToPeripheralsAtChannel:thisExpressChannel filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([peripheralName isEqualToString:name]) {
            return YES;
        }
        return NO;
    }];
    
    baby.channel(thisExpressChannel).scanForPeripherals().enjoy();
}

- (void)startFromScanBlock:(BOOL (^) (NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))block{
    __weak __typeof(self) weakSelf = self;
    
    [baby setFilterOnConnectToPeripheralsAtChannel:thisExpressChannel filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (weakSelf.filterDiscoverBlock(peripheralName,advertisementData,RSSI)) {
            return YES;
        }
        return NO;
    }];
    
    baby.channel(thisExpressChannel).scanForPeripherals().enjoy();
}



/**
 从连接开始启动
 */
- (void)startFromConnectWithPeripheral:(CBPeripheral *) peripheral {
    baby.channel(thisExpressChannel).having(peripheral).enjoy();
}
- (void)startFromConnectWithPeripheralUUIDString:(NSString *) UUIDString {
    baby.channel(thisExpressChannel).having([baby retrievePeripheralWithUUIDString:UUIDString]).enjoy();
}


#pragma mark - 委托


/*
 设备管理器状态变化
 
 Yes:可用
 No:不可用
 */
- (void)onUpdateState:(void (^) (BOOL enable))block {
    self.updateStateBlock = block;
}


- (void)onReady:(void (^)(CBPeripheral *peripheral))block {
    self.onReadyBlock = block;
}

//特征值解析
//- (void)onRecivedDataForParse:(NSString * (^)(NSString *CUUID))block;
//- (void)onRecivedData:(NSString * (^)(NSString *CUUID))block;
//
//
//- (void)onReConncet:(void (^)(NSUInteger *reConnectTimes))block;


#pragma mark - XYExpressActivityDelegate 收到数据通知
- (void)received:(NSDictionary *)data type:(NSString *)type {
    
}
- (void)error:(NSError *)error type:(NSString *)type {
    
}
#pragma mark - 私有方法



@end
