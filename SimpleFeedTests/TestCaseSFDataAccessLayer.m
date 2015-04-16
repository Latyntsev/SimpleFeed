//
//  TestCaseSFDataAccessLayer.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SFDataAccessLayer.h"
#import "SFDataSource.h"
#import "SFWebService.h"

extern NSString *const twitterLink;
extern NSString *const key;
extern NSString *const secret;

@interface TestCaseSFDataAccessLayer : XCTestCase

@property (nonatomic,strong) SFDataAccessLayer *instance;

@end

@implementation TestCaseSFDataAccessLayer

- (void)setUp {
    [super setUp];
    SFWebService *webService = [[SFWebService alloc] init];
    SFDataSource *dataSource = [[SFDataSource alloc] initWithWebServer:webService];
    self.instance = [[SFDataAccessLayer alloc] initWithDataSource:dataSource
                                          andManagedObjectContext:nil key:key
                                                           secret:secret];
}

- (void)test_asd {
    [self.instance getFeedForUser:@"dubizzle" withComplitionBlock:^(Timeline *timeline, NSError *error, SFResponseStatus responseStatus) {
        
    }];
}



@end
