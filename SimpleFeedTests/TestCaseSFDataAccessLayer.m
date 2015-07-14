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
#import "SFConfiguration.h"
#import "AppDelegate.h"

@interface TestCaseSFDataAccessLayer : XCTestCase

@property (nonatomic,strong) SFDataAccessLayer *instance;

@end

@implementation TestCaseSFDataAccessLayer

- (void)setUp {
    [super setUp];
    
    AppDelegate *applicationDelegate = [UIApplication sharedApplication].delegate;
    
    SFWebService *webService = [[SFWebService alloc] init];
    SFDataSource *dataSource = [[SFDataSource alloc] initWithWebServer:webService];
    self.instance = [[SFDataAccessLayer alloc] initWithDataSource:dataSource
                                          andManagedObjectContext:applicationDelegate.dataAccessLayer.managedObjectContext
                                                              key:twitterKey
                                                           secret:twitterSecret];
}

- (void)test_getFeedForUser_withComplitionBlock {
    
    __block BOOL executed = false;
    XCTestExpectation *expectation = [self expectationWithDescription:@"waiting for execution"];
    [self.instance getFeedForUser:kDefaultUserName withComplitionBlock:^(Profile *timeline, NSError *error) {
        executed = true;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:4 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    XCTAssertTrue(executed);
    
    [self.instance getFeedForUser:kDefaultUserName withComplitionBlock:nil];
}

- (void)test_tuneImageSizeLink {
    
    XCTAssertEqualObjects([self.instance tuneImageSizeLink:@"http://link.com/id_normal.png"],@"http://link.com/id.png");
    XCTAssertEqualObjects([self.instance tuneImageSizeLink:@"http://link.com/_normal.id_normal.png"],@"http://link.com/_normal.id.png");
    XCTAssertNil([self.instance tuneImageSizeLink:nil]);
    XCTAssertEqualObjects([self.instance tuneImageSizeLink:@"http://link.com/id.png"],@"http://link.com/id.png");
}


@end
