//
//  XYPairing.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

@interface XYPairing : NSObject

//开启配对
- (void)start:(void (^)(CBPeripheral *CBPeripheral,NSDictionary *advertisementData,NSNumber *RSSI,NSString *MAC))receivedAdvertisement;

//配对成功，关闭配对
- (void)done;

@end
