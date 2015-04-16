//
//  SFDataAccessLayer.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFDataSource;

@interface SFDataAccessLayer : NSObject

- (instancetype)initWithDataSource:(SFDataSource *)dataSource;

@end
