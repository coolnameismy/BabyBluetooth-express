//
//  XYConnecting.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "XYConnecting.h"
#import "XYExpressDelegate.h"


@interface XYConnecting : NSObject



#pragma  mark -  启动连接

/**
 启动
 1：在有UUID时，首先通过UUID直连设备，如果连接不上则开启扫描，扫描到设备后会连接
 2：连接设备后会扫描和发现设备的全部服务和特征值，会把所有的特征值读取一次
 3：读取设备数据时会先进
 4：全部操作完成会回叫ready方法，开发者可以在ready方法实现自己的逻辑
 */
- (void)connectWithName:(NSString *)nameCondition;
- (void)connectWithUUIDString:(NSString *)nameCondition;
- (void)connectWithBlock:(BOOL (^) (NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))block;



 #pragma  mark - 方法
  

 
 
 #pragma  mark - 属性
/**
 数据回调委托
 */
@property (nonatomic, weak) id <XYEpressDelegate> delegate;

@end


