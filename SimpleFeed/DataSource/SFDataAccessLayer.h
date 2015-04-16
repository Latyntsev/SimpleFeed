//
//  SFDataAccessLayer.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObjectContext;
@class SFDataSource;
@class Timeline;
@class UIImage;

@interface SFDataAccessLayer : NSObject

typedef NS_ENUM(NSInteger, SFResponseStatus) {
    SFResponseStatus_cachedData, //will be an other response
    SFResponseStatus_finalResponse //actual data
};

- (instancetype)initWithDataSource:(SFDataSource *)dataSource andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSOperationQueue *)queue;

typedef void(^SFDataAccessLayerGetFeedComplitionBlock)(Timeline *timeline, NSError *error, SFResponseStatus responseStatus);
- (NSOperation *)getFeedForUser:(NSString *)user withComplitionBlock:(SFDataAccessLayerGetFeedComplitionBlock)complitionBlock;

typedef void(^DownloadImageComplitionBlock)(UIImage *image, NSString *link, NSTimeInterval loadingDuration);
- (void)downloadImageWithLink:(NSString *)link complitionBlock:(DownloadImageComplitionBlock)complitionBlock;

@end
