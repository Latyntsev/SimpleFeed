//
//  SFWebService.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFWebService : NSObject

typedef void(^SFWebServiceComplitionBlock)(NSData *data,NSError *error, NSURLRequest *request, NSURLResponse *response);

- (instancetype)initWithServiceURL:(NSURL *)serviceURL;

- (void)authorizeWithKey:(NSString *)key andSecret:(NSString *)secret complitionBlock:(SFWebServiceComplitionBlock)complitionBlock;

- (void)getTwitterFeedForUser:(NSString *)user count:(NSInteger)count token:(NSString *)token complitionBlock:(SFWebServiceComplitionBlock)complitionBlock;

@end
