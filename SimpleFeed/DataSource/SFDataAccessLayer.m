//
//  SFDataAccessLayer.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFDataAccessLayer.h"
#import "SFDataSource.h"

@interface SFDataAccessLayer ()

@property (nonatomic,strong) SFDataSource *dataSource;
@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation SFDataAccessLayer

- (instancetype)initWithDataSource:(SFDataSource *)dataSource {
    
    NSAssert(dataSource, @"data Source is required");
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}



@end
