//
//  XYExpressDelegate.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/22.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>


@class XYConnecting;

@protocol XYEpressDelegate <NSObject>


/**
 扫描连接发现服务特征和值完成，业务逻辑入口
 
 说明：这个方法作为自定义的业务逻辑的入口,外设所有的服务，特征和特征值数据集合完成后回调
 **/
- (void)express:(XYConnecting *)express onReady:(CBPeripheral *)peripheral;


/**
 解析数据
 
 收到数据后会首先进入数据解析，方法会把解析后的数据传入onRecivedData方法，如果不需要做解析可以直接返回接收的数据
 */
- (void)express:(XYConnecting *)express parseData:(NSData *)data;
- (void)express:(XYConnecting *)express onRecivedData:(NSDictionary *)data;


/**
 收到ble事件通知
 
 事件类型： 设备管理器状态改变，连接设备，断开连接，
 */
- (void)express:(XYConnecting *)express notificationOn:(NSString *)event withData:(NSDictionary *)data;


@end
