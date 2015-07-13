//
//  SFWebService.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFWebService.h"

@interface SFWebService ()

@property (nonatomic,strong) NSURL *serviceURL;

@end

@implementation SFWebService

- (instancetype)initWithServiceURL:(NSURL *)serviceURL {
    NSAssert(serviceURL, @"Service URL is required");
    self = [super init];
    if (self) {
        self.serviceURL = serviceURL;
    }
    return self;
}

- (NSString *)parametresToString:(NSDictionary *)parametres {
    if (!parametres) {
        return @"";
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *key in parametres.allKeys) {
        id value = parametres[key];
        value = [value description];
        if ([value description].length == 0) {
            continue;
        }
        NSString *name = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *pair = [NSString stringWithFormat:@"%@=%@",name,value];
        
        [mutableArray addObject:pair];
    }
    NSString *result = [mutableArray componentsJoinedByString:@"&"];
    
    return result;
}

- (NSURL *)serviceURLForResourcePath:(NSString *)resourcePath {
    if (resourcePath.length == 0) {
        return self.serviceURL;
    }
    return [self.serviceURL URLByAppendingPathComponent:resourcePath];
}

- (NSURL *)addQueryParametres:(NSDictionary *)parametres toURL:(NSURL *)url {
    NSAssert(url, @"URL is required");
    NSString *parametresString = [self parametresToString:parametres];
    if (parametresString.length == 0) {
        return url;
    }
    NSString *stringURL = url.absoluteString;
    if ([stringURL rangeOfString:@"?"].length > 0) {
        if ([stringURL hasSuffix:@"?"]) {
            stringURL = [stringURL stringByAppendingFormat:@"%@",parametresString];
        } else {
            stringURL = [stringURL stringByAppendingFormat:@"&%@",parametresString];
        }
    } else {
        stringURL = [stringURL stringByAppendingFormat:@"?%@",parametresString];
    }
    return [NSURL URLWithString:stringURL];
}

- (NSMutableURLRequest *)requestResource:(NSString *)resource {
    return [self requestResource:resource withParametres:nil];
}

- (NSMutableURLRequest *)requestResource:(NSString *)resource withParametres:(NSDictionary *)parametres {
    NSURL *url = [self serviceURLForResourcePath:resource];
    url = [self addQueryParametres:parametres toURL:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    return request;
}

- (void)addBody:(NSMutableURLRequest *)request parametres:(NSDictionary *)paramentres {
    NSString *paramString = [self parametresToString:paramentres];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)executeRequest:(NSURLRequest *)request complitionBlock:(SFWebServiceComplitionBlock)complitionBlock {
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (complitionBlock) {
        complitionBlock(data, error, request, response);
    }
}



- (void)addHeaderAuthorization:(NSMutableURLRequest *)request withBearerKey:(NSString *)key andSecret:(NSString *)secret {
    NSString *basic = [NSString stringWithFormat:@"%@:%@",key,secret];
    basic = [[basic dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    NSString *authorization = [NSString stringWithFormat:@"Basic %@",basic];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
}

- (void)addHeaderAuthorization:(NSMutableURLRequest *)request withBearerToken:(NSString *)token {
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
}




- (void)authorizeWithKey:(NSString *)key andSecret:(NSString *)secret complitionBlock:(SFWebServiceComplitionBlock)complitionBlock {

    NSMutableURLRequest *request = [self requestResource:@"/oauth2/token"];
    request.HTTPMethod = @"POST";
    [self addHeaderAuthorization:request withBearerKey:key andSecret:secret];
    [self addBody:request parametres:@{@"grant_type":@"client_credentials"}];
    [self executeRequest:request complitionBlock:complitionBlock];
}

- (void)getTwitterFeedForUser:(NSString *)user count:(NSInteger)count token:(NSString *)token complitionBlock:(SFWebServiceComplitionBlock)complitionBlock {
    
    NSMutableURLRequest *request = [self requestResource:@"/1.1/statuses/user_timeline.json"
                                          withParametres:@{@"screen_name":user,@"count":@(count)}];
    
    [self addHeaderAuthorization:request withBearerToken:token];
    [self executeRequest:request complitionBlock:complitionBlock];
}

- (void)getTwitterUserInfo:(NSString *)user token:(NSString *)token complitionBlock:(SFWebServiceComplitionBlock)complitionBlock {
    
    NSMutableURLRequest *request = [self requestResource:@"/1.1/users/show.json"
                                          withParametres:@{@"screen_name":user}];
    
    [self addHeaderAuthorization:request withBearerToken:token];
    [self executeRequest:request complitionBlock:complitionBlock];
}

@end
