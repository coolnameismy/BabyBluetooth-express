//
//  babybluetooth_express_demoTests.m
//  babybluetooth-express-demoTests
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYExpress.h"

@interface babybluetooth_express_demoTests : XCTestCase

@property (nonatomic, strong) XYExpress *express;

@end

@implementation babybluetooth_express_demoTests



- (void)setUp {
    [super setUp];
     self.express = [[XYExpress alloc]init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
