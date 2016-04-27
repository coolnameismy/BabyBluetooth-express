//
//  babybluetooth_express_demoTests.m
//  babybluetooth-express-demoTests
//
//  Created by xuanyan.lyw on 16/4/17.
//  Copyright © 2016年 coolnameismy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYExpress.h"
#import "BabyBluetooth.h"


@interface babybluetooth_express_demoTests : XCTestCase<XYEpressDelegate>

@property (nonatomic, strong) XYExpress *express;
@property (nonatomic, strong) XYConnecting *connecting;

@property (nonatomic, strong) BabyBluetooth *baby1;
@property (nonatomic, strong) BabyBluetooth *baby2;

@end

@implementation babybluetooth_express_demoTests

NSString * const testPeripleralName = @"BabyBluetoothTestStub";

# warning testPeripleralUUIDString这个值会根据不同设备变化的,同一个设备也可能用为重启会产生变化，可以通过打印 [[peripheral identifier] UUIDString]] 取得
NSString * const testPeripleralUUIDString = @"FD9C47C0-B6A8-2D91-BD7D-C91810654EE8";

NSString * const testPeripleralName2 = @"baby-default-name";
NSString * const testPeripleralUUIDString2 = @"278EDE11-E237-2CB8-AEF2-CBAFCB3486C7";

- (instancetype)init
{
    self = [super init];
    if (self) {
//        XYConnecting *connecting = [[XYConnecting alloc]init];
//        connecting.delegate = self;
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

- (void)testDirectConnect {
    BabyBluetooth *baby1 = [[BabyBluetooth alloc]init];
    BabyBluetooth *baby2 = [[BabyBluetooth alloc]init];
    NSLog(@"%@",baby1.centralManager);
    NSLog(@"%@",baby2.centralManager);
    
    //    CBCentralManager *centralManager = [[CBCentralManager alloc]init];
    //    NSLog(@"%@",centralManager);
    
//    CBPeripheral *p = [baby1 retrievePeripheralWithUUIDString:testPeripleralUUIDString];
//    CBPeripheral *p2 = [baby2 retrievePeripheralWithUUIDString:testPeripleralUUIDString2];
    
    
    [baby1 setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"baby1 搜索到了设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName]) {
            return YES;
        }
        return NO;
    }];
    
    [baby1 setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"baby1 discover");
    }];
    __block NSInteger connectTimes = 0;
    [baby1 setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"baby1:%@ connect at %d times",peripheral.name,++connectTimes);
    }];
    
    [baby1 setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"baby1 disconnect | name is :%@",peripheral.name);
        [central connectPeripheral:peripheral options:nil];
    }];
    
    //等待ble状态打开后连接
    [baby1 setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [central connectPeripheral:p options:nil];
        }
    }];
    
    baby1.scanForPeripherals().connectToPeripherals().begin();
    
    
    [baby2 setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"baby2 搜索到了设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName2]) {
            return YES;
        }
        return NO;
    }];
    
    __block NSInteger connectTimes2 = 0;
    [baby2 setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"baby2:%@ connect at %d times",peripheral.name,++connectTimes2);
    }];
    [baby2 setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"baby2 disconnect | name is :%@",peripheral.name);
        [central connectPeripheral:peripheral options:nil];
    }];
    
    //
    //    baby2.having(p).connectToPeripherals().begin();
    
    //    [baby1.centralManager connectPeripheral:p options:nil];
    //    [baby2.centralManager connectPeripheral:p options:nil];
    
    [baby2 setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [central connectPeripheral:p2 options:nil];
        }
    }];
    baby2.scanForPeripherals().connectToPeripherals().begin();
    //    NSLog(@"%@",p.services);
    
    
    XCTestExpectation *exp = [self expectationWithDescription:@"a"];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
    
}

- (void)testMutableBleManagerLifestyle {
    self.baby1 = [[BabyBluetooth alloc]init];
    self.baby2 = [[BabyBluetooth alloc]init];
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
   
    
    NSLog(@"%@",self.baby1.centralManager);
    NSLog(@"%@",self.baby2.centralManager);

    [self.baby1 setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"baby1 discover peripheral :%@",peripheral);
    }]; 
    
    [self.baby2 setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"baby2 discover peripheral :%@",peripheral);
    }];
    
    //等待ble状态打开后连接
    [self.baby1 setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            NSLog(@"baby1 isScanning,%hhd ",central.isScanning);
            [central scanForPeripheralsWithServices:nil options:scanForPeripheralsWithOptions];
        }
    }];
    
    //等待ble状态打开后连接
    [self.baby2 setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            NSLog(@"baby2 isScanning,%hhd ",central.isScanning);
            [central scanForPeripheralsWithServices:nil options:scanForPeripheralsWithOptions];
        }
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(ticket) userInfo:nil repeats:YES];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"a"];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
    
}

- (void)ticket {
    
}


- (void)express:(XYConnecting *)express notificationOn:(NSString *)event withData:(NSDictionary *)data {
    NSLog(@"event:%@,data:%@",event,data);
}

@end
