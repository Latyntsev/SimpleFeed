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

@interface SFWebService ()

- (void)executeRequest:(NSURLRequest *)request withComplitionBlock:(SFWebServiceComplitionBlock)complitionBlock;

@end

@implementation SFWebService (test)

- (instancetype)init {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/"];
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
    
    NSString *key = @"hws3MrA6qCOp0Mc9o0BgxA";
    NSString *secret = @"6yAbeJXiRLhzyfTAYn11n3oqxne9FxWWn5JQvzZl0Tc";
    [self.instance authorizeWithKey:key andSecret:secret complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        XCTAssert(data);
        XCTAssertNil(error);
        XCTAssert(request);
        XCTAssert(response);
    }];
    
    [self.instance authorizeWithKey:key andSecret:secret complitionBlock:nil];
}

- (void)test_getTwitterFeedForUser_count_complitionBlock {
    
    [self.instance getTwitterFeedForUser:@"latyntsev" count:12 token:@"" complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        XCTAssert(data);
        XCTAssertNil(error);
        XCTAssert(request);
        XCTAssert(response);
    }];
    
}

@end
