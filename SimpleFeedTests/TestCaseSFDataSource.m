//
//  TestCaseSFDataSource.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SFDataSource.h"
#import "SFWebService.h"

@interface TestCaseSFDataSource : XCTestCase

@property (nonatomic,strong) SFDataSource *instance;

@end

@implementation TestCaseSFDataSource

- (void)setUp {
    [super setUp];
    SFWebService *webService = [[SFWebService alloc] init];
    self.instance = [[SFDataSource alloc] initWithWebServer:webService];
}

- (void)test_getFeedWithComplitionBlock {
    
    NSString *user = @"dubizzle";
    [self.instance getFeedForUser:user withComplitionBlock:^(NSArray *data, NSError *error) {
        XCTAssert(data);
        XCTAssertNil(error);
    }];
    
    [self.instance getFeedForUser:user withComplitionBlock:nil];
}

- (void)test_authorizeWithKey_andSecret_complitionBlock {
    
    NSString *key = @"hws3MrA6qCOp0Mc9o0BgxA";
    NSString *secret = @"6yAbeJXiRLhzyfTAYn11n3oqxne9FxWWn5JQvzZl0Tc";
    
    [self.instance authorizeWithKey:key andSecret:secret complitionBlock:^(NSError *error) {
        XCTAssertNil(error);
    }];
    
    [self.instance authorizeWithKey:key andSecret:secret complitionBlock:nil];
}

- (void)test_authorize {
    
    NSString *key = @"hws3MrA6qCOp0Mc9o0BgxA";
    NSString *secret = @"6yAbeJXiRLhzyfTAYn11n3oqxne9FxWWn5JQvzZl0Tc";
    
    XCTAssertFalse(self.instance.isAutorized);
    [self.instance authorizeWithKey:key andSecret:key complitionBlock:nil];
    XCTAssertFalse(self.instance.isAutorized);
    
    [self.instance authorizeWithKey:key andSecret:secret complitionBlock:nil];
    XCTAssertTrue(self.instance.isAutorized);
    
    [self.instance authorizeWithKey:key andSecret:key complitionBlock:nil];
    XCTAssertFalse(self.instance.isAutorized);
}


@end