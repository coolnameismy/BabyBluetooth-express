//
//  XYExpressActivityDelegate.h
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/18.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYExpressActivityDelegate <NSObject>

- (void)received:(NSDictionary *)data type:(NSString *)type;
- (void)error:(NSError *)error type:(NSString *)type;

@end
