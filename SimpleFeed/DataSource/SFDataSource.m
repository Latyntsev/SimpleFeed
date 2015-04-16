//
//  SFDataSource.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFDataSource.h"
#import "SFWebService.h"

@interface SFDataSource ()

@property (nonatomic,strong) SFWebService *webService;
@property (nonatomic,strong) NSString *accessToken;
@end


@implementation SFDataSource

- (instancetype)initWithWebServer:(SFWebService *)webService {
    
    NSAssert(webService, @"Web service is required");
    self = [super init];
    if (self) {
        self.webService = webService;
    }
    
    return self;
}

- (NSString *)domain {
    return @"app.dataSource";
}

- (void)parseData:(NSData *)data andComplitionBlock:(void(^)(id object, NSError *error))complitionBlock {
    
    NSError *error = nil;
    id object = nil;
    if (data) {
        object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            object = nil;
        }
    } else {
        NSString *errorMessage = NSLocalizedString(@"Data not available", nil);
        error = [NSError errorWithDomain:self.domain code:1 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    }
    
    complitionBlock(object,error);
}

- (BOOL)isAutorized {
    return self.accessToken.length > 0;
}

- (void)authorizeWithKey:(NSString *)key andSecret:(NSString *)secret complitionBlock:(SFDataSourceAuthorizeComplitionBlock)complitionBlock {
    
    NSAssert(key, @"key is required");
    NSAssert(secret, @"secret is required");
    NSString *domain = @"app.dataSource.authorize";
    self.accessToken = nil;
    [self.webService authorizeWithKey:key andSecret:secret complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        
        __block id object = nil;
        
        if (!error) {
            __block NSError *theParsingError = nil;
            [self parseData:data andComplitionBlock:^(id jsonObject, NSError *parsingError) {
                object = jsonObject;
                theParsingError = parsingError;
            }];
            error = theParsingError;
        }
        
        if (!error) {
            if (object[@"errors"]) {
                NSDictionary *errorObject = object[@"errors"][0];
                error = [NSError errorWithDomain:domain
                                            code:[errorObject[@"code"] integerValue]
                                        userInfo:@{NSLocalizedDescriptionKey:errorObject[@"message"]}];
                
            } else if (!object[@"access_token"]) {
                
                error = [NSError errorWithDomain:domain code:1
                                        userInfo:@{NSLocalizedDescriptionKey:@"access_token is not found"}];
            }
        }
        
        if (!error) {
            self.accessToken = object[@"access_token"];
        }
        if (complitionBlock) {
            complitionBlock(error);
        }
    }];
}

- (void)getFeedForUser:(NSString *)user withComplitionBlock:(SFDataSourceGetFeedComplitionBlock)complitionBlock {
    
    NSAssert(user, @"user is required");
    [self.webService getTwitterFeedForUser:user count:100 token:self.accessToken complitionBlock:^(NSData *data, NSError *error, NSURLRequest *request, NSURLResponse *response) {
        __block id object = nil;
        
        if (!error) {
            __block NSError *theParsingError = nil;
            [self parseData:data andComplitionBlock:^(id jsonObject, NSError *parsingError) {
                object = jsonObject;
                theParsingError = parsingError;
            }];
            error = theParsingError;
        }
        if (complitionBlock) {
            complitionBlock(object,error);
        }
    }];
}

@end
