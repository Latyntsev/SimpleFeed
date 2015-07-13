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

@interface TestCaseSFDataAccessLayer : XCTestCase

@property (nonatomic,strong) SFDataAccessLayer *instance;

@end

@implementation TestCaseSFDataAccessLayer

- (void)setUp {
    [super setUp];
    SFWebService *webService = [[SFWebService alloc] init];
    SFDataSource *dataSource = [[SFDataSource alloc] initWithWebServer:webService];
    self.instance = [[SFDataAccessLayer alloc] initWithDataSource:dataSource
                                          andManagedObjectContext:nil
                                                              key:twitterKey
                                                           secret:twitterSecret];
}

- (void)test_asd {
    [self.instance getFeedForUser:kDefaultUserName withComplitionBlock:^(Timeline *timeline, NSError *error) {
        
    }];
}



@end
