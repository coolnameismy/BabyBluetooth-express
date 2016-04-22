//
//  babybluetooth_express_demoTests.m
//  babybluetooth-express-demoTests
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYExpress.h"



@interface babybluetooth_express_demoTests : XCTestCase<XYEpressDelegate>

@property (nonatomic, strong) XYExpress *express;
@property (nonatomic, strong) XYConnecting *connecting;

@end

@implementation babybluetooth_express_demoTests

NSString * const testPeripleralName = @"BabyBluetoothTestStub";

# warning testPeripleralUUIDString这个值会根据不同设备变化的，可以通过打印 [[peripheral identifier] UUIDString]] 取得
NSString * const testPeripleralUUIDString = @"B19A6ED7-29D5-67EF-0207-6F5AE8BC337B";

- (instancetype)init
{
    self = [super init];
    if (self) {
        XYConnecting *connecting = [[XYConnecting alloc]init];
        connecting.delegate = self;
    }
    return self;
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *exp = [self expectationWithDescription:@"a"];
    [self.connecting connectWithUUIDString:testPeripleralUUIDString];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)express:(XYConnecting *)express notificationOn:(NSString *)event withData:(NSDictionary *)data {
    NSLog(@"event:%@,data:%@",event,data);
}

@end
