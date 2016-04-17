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

@end

@implementation XYExpress




- (instancetype)init
{
    self = [super init];
    if (self) {
        baby = [BabyBluetooth shareBabyBluetooth];
        thisExpressChannel = [[NSUUID UUID]UUIDString];
    }
    return self;
}

- (void)dealloc {
    
}

- (NSMutableArray *)ExpressList {
    return [XYExpressDistributer shareExpressList];
}

- (void)setCommonDelegate {
    __weak __typeof(self) weakSelf = self;
    
    //设置委托
    [baby setBlockOnCentralManagerDidUpdateStateAtChannel:thisExpressChannel block:^(CBCentralManager *central) {
        weakSelf.updateStateBlock(central.state == CBCentralManagerStatePoweredOn);
    }];
    //设置断线重连
}

//- (XYExpress *)findExpress

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
    
    [self setCommonDelegate];
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
    
    [self setCommonDelegate];
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

/**
 外设准备完成
 
 说明：这个方法作为自定义的业务逻辑的入口
 **/
//- (void)onReady:(BabyBluetooth_express *)express;

//特征值解析
//- (void)onRecivedDataForParse:(NSString * (^)(NSString *CUUID))block;
//- (void)onRecivedData:(NSString * (^)(NSString *CUUID))block;
//
//
//- (void)onReConncet:(void (^)(NSUInteger *reConnectTimes))block;


#pragma mark - 私有方法



@end
