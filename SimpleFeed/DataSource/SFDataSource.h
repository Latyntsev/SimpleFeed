//
//  SFDataSource.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFWebService;

@interface SFDataSource : NSObject

typedef void(^SFDataSourceAuthorizeComplitionBlock)(NSError *error);
typedef void(^SFDataSourceGetFeedComplitionBlock)(NSArray *data,NSError *error);

- (instancetype)initWithWebServer:(SFWebService *)webService;

- (BOOL)isAutorized;

- (void)authorizeWithKey:(NSString *)key andSecret:(NSString *)secret complitionBlock:(SFDataSourceAuthorizeComplitionBlock)complitionBlock;

- (void)getFeedWithComplitionBlock:(SFDataSourceGetFeedComplitionBlock)complitionBlock;

@end
