//
//  ViewController.m
//  babybluetooth-express-demo
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import "ViewController.h"


@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XYConnecting *connecting = [[XYConnecting alloc]init];
    connecting.delegate = self;
    [connecting connectWithUUIDString:@""];
    
}

/**
 说明：这个方法作为自定义的业务逻辑的入口,外设所有的服务，特征和特征值数据集合完成后回调
 **/
- (void)express:(XYConnecting *)express onReady:(CBPeripheral *)peripheral {
    
    
}


@end
