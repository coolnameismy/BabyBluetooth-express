//
//  XYExpressDistributer.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "XYExpressDistributer.h"


@implementation XYExpressDistributer



//单例expressList
+ (NSMutableArray *)shareExpressList {
    static NSMutableArray *expressList;
    if (!expressList) {
        expressList = [[NSMutableArray alloc]init];
    }
    return expressList;
}




@end
