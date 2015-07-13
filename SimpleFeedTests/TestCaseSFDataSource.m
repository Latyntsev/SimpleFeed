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
#import "SFConfiguration.h"

@interface TestCaseSFDataSource : XCTestCase

@property (nonatomic,strong) SFDataSource *instance;

@end

@implementation TestCaseSFDataSource

- (void)setUp {
    [super setUp];
    SFWebService *webService = [[SFWebService alloc] init];
    self.instance = [[SFDataSource alloc] initWithWebServer:webService];
}

- (void)test_getFeedForUser_withComplitionBlock {
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:nil];
    
    __block BOOL executed = false;
    [self.instance getFeedForUser:kDefaultUserName withComplitionBlock:^(NSArray *data, NSError *error) {
        executed = true;
        XCTAssert(data);
        XCTAssertNil(error);
    }];
    XCTAssertTrue(executed);
    
    [self.instance getFeedForUser:kDefaultUserName withComplitionBlock:nil];
}

- (void)test_authorizeWithKey_andSecret_complitionBlock {
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:^(NSError *error) {
        XCTAssertNil(error);
    }];
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:nil];
}

- (void)test_authorize {
    
    XCTAssertFalse(self.instance.isAutorized);
    [self.instance authorizeWithKey:twitterKey andSecret:twitterKey complitionBlock:nil];
    XCTAssertFalse(self.instance.isAutorized);
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:nil];
    XCTAssertTrue(self.instance.isAutorized);
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterKey complitionBlock:nil];
    XCTAssertFalse(self.instance.isAutorized);
}

- (void)test_getUserInfo_withComplitionBlock {
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:nil];
    
    __block BOOL executed = false;
    [self.instance getUserInfo:kDefaultUserName withComplitionBlock:^(NSDictionary *data, NSError *error) {
        executed = true;
        XCTAssert(data);
        XCTAssertNil(error);
    }];
    XCTAssertTrue(executed);
    
    [self.instance getUserInfo:kDefaultUserName withComplitionBlock:nil];
}

@end