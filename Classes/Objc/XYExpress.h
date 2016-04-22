//
//  BabyBluetooth-express.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "XYExpressManager.h"
#import "XYExpressActivityDelegate.h"
#import "XYConnecting.h"
#import "XYExpressDelegate.h"

#define KCONNECT @"KCONNECT"
#define KDISCOVERS @"KDISCOVERS"
#define KDISCOVERC @"KDISCOVERC"
#define KREADC @"KREADC"
#define KDISCONNECT @"KDISCONNECT"
#define KREADVALUE @"KREADVALUE"
#define KNOTIYVALUE @"KNOTIYVALUE"



@interface XYExpress : NSObject<XYExpressActivityDelegate>


typedef void (^XYUpdateStateBlock)(BOOL enable);
typedef BOOL (^XYFilterDiscoverBlock)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI);
typedef void (^XYOnReadyBlock)(CBPeripheral *peripheral);

@property (nonatomic , copy) CBPeripheral *thePeripheral;

#pragma mark - 方法

/**
 从扫描开始启动
*/
- (void)startWithNameCondition:(NSString *)nameCondition;
- (void)startFromScanBlock:(BOOL (^) (NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))block;

/**
 从连接开始启动
 */
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
 设备管理器状态变化,后续错误，发现设备，连接设备，
 
*/
- (void)onUpdateState:(void (^) (BOOL enable))block;

/**

 说明：这个方法作为自定义的业务逻辑的入口,外设所有的服务，特征和特征值数据集合完成后回调
 **/
- (void)onReady:(void (^)(CBPeripheral *peripheral))block;

//特征值解析
- (BOOL)dataForParse:(NSString * (^)(NSString *CUUID))block;
- (void)onRecivedParseData:(void * (^)(NSDictionary *data))block;
- (void)onRecivedUnparseData:(void * (^)(NSData *data))block;

- (void)onReConncet:(void (^)(NSUInteger *reConnectTimes))block;


@end




