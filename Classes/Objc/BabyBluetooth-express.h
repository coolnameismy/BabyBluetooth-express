//
//  BabyBluetooth-express.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"


@interface BabyBluetooth_express : NSObject


#pragma mark - 方法

/**
 从扫描开始启动
*/
- (void)startFromScanWithUUIDString:(NSString *)UUID;
- (void)startFromScanWithName:(NSString *)name;
- (void)startFromScanBlick:(BOOL (^) (NSString *peripheralName, NSString *MAC, NSDictionary *advertisementData, NSNumber *RSSI))block;

- (void)startFromScan:(NSString *)condition;

/**
 从连接开始启动
 */
- (void)startFromConnectWithPeripheral:(CBPeripheral *)peripheral;
- (void)startFromConnectWithPeripheralUUIDString:(NSString *)UUIDString;

/**
 读数据
 */
- (void)read:(NSString *)UUIDString;
/**
 写数据
 */
- (void)write:(NSString *)UUIDString;
/**
 订阅数据
 */
- (void)notify:(NSString *)UUIDString;


#pragma mark - 委托


/*
 设备管理器状态变化
 
 Yes:可用
 No:不可用
*/
- (void)onUpdateState:(void (^)(BOOL *enable))block ;

/**
 外设准备完成
 
 说明：这个方法作为自定义的业务逻辑的入口
 **/
- (void)onReady:(BabyBluetooth_express *)express;

//特征值解析
- (void)onRecivedDataForParse:(NSString * (^)(NSString *CUUID))block;
- (void)onRecivedData:(NSString * (^)(NSString *CUUID))block;


- (void)onReConncet:(void (^)(NSUInteger *reConnectTimes))block;


@end
