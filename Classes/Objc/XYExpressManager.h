//
//  XYExpressDistributer.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
@class XYExpress;

@interface XYExpressManager : NSObject

@property (nonatomic ,strong) BabyBluetooth *baby;
@property (nonatomic ,strong) NSMutableArray *list;



//单例expressList
+ (instancetype)shareExpressManager;

- (void)registerExpress:(XYExpress *)express ;
- (void)unregisterExpress:(XYExpress *)express;


@end




