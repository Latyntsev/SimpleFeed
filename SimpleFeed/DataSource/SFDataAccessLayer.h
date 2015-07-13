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
@class NSFetchRequest;

@interface SFDataAccessLayer : NSObject

- (instancetype)initWithDataSource:(SFDataSource *)dataSource
           andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                               key:(NSString *)key
                            secret:(NSString *)secret;

- (NSOperationQueue *)queue;
- (NSManagedObjectContext *)managedObjectContext;


typedef void(^SFDataAccessLayerGetFeedComplitionBlock)(Timeline *timeline, NSError *error);
- (NSOperation *)getFeedForUser:(NSString *)user withComplitionBlock:(SFDataAccessLayerGetFeedComplitionBlock)complitionBlock;

typedef void(^DownloadImageComplitionBlock)(UIImage *image, NSString *link, BOOL isCacheValue);
- (void)downloadImageWithLink:(NSString *)link complitionBlock:(DownloadImageComplitionBlock)complitionBlock;

- (NSFetchRequest *)fetchRequestTwitterItemForUserName:(NSString *)userName;

@end
