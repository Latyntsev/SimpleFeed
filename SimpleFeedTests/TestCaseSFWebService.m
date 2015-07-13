//
//  TestCaseSFWebService.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SFWebService.h"
#import "SFConfiguration.h"

@interface SFWebService ()

- (void)executeRequest:(NSURLRequest *)request withComplitionBlock:(SFWebServiceComplitionBlock)complitionBlock;

@end

@implementation SFWebService (test)

- (instancetype)init {
    NSURL *url = [NSURL URLWithString:twitterLink];
    return [self initWithServiceURL:url];
}

@end

@interface TestCaseSFWebService : XCTestCase

@property (nonatomic,strong) SFWebService *instance;

@end

@implementation TestCaseSFWebService

- (void)setUp {
    [super setUp];
    
    self.instance = [[SFWebService alloc] init];
}

- (void)test_authorizeWithKey_andSecret_complitionBlock {
    
    __block BOOL executed = false;
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        executed = true;
        XCTAssert(data);
        XCTAssertNil(error);
        XCTAssert(request);
        XCTAssert(response);
    }];
    
    XCTAssertTrue(executed);
    
    [self.instance authorizeWithKey:twitterKey andSecret:twitterSecret complitionBlock:nil];
}

- (void)test_getTwitterFeedForUser_count_complitionBlock {
    
    
    __block BOOL executed = false;
    [self.instance getTwitterFeedForUser:kDefaultUserName count:12 token:@"" complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        executed = true;
        XCTAssert(data);
        XCTAssertNil(error);
        XCTAssert(request);
        XCTAssert(response);
    }];
    XCTAssertTrue(executed);
}

- (void)test_getTwitterUserInfo_token_complitionBlock {
    
    __block BOOL executed = false;
    [self.instance getTwitterUserInfo:kDefaultUserName token:@"" complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        executed = true;
        
        XCTAssert(data);
        XCTAssertNil(error);
        XCTAssert(request);
        XCTAssert(response);
    }];
    
    XCTAssertTrue(executed);
    
    [self.instance getTwitterUserInfo:kDefaultUserName token:@"" complitionBlock:nil];
}

@end
