//
//  BabyBluetooth-express.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "BabyBluetooth-express.h"

@implementation BabyBluetooth_express


//单例模式
+ (instancetype)shareExpress {
    static BabyBluetooth_express *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[BabyBluetooth_express alloc]init];
    });
    return share;
}



@end
