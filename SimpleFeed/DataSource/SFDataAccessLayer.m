//
//  SFDataAccessLayer.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFDataAccessLayer.h"
#import "SFDataSource.h"
#import "SFModel.h"
#import <UIKit/UIKit.h>

@interface SFLoadingImageItem : NSObject

@property (nonatomic,copy) DownloadImageComplitionBlock complitionBlock;
@property (nonatomic,strong) NSDate *dateAdded;
@property (nonatomic,strong) NSString *link;


- (void)executeBlockForImage:(UIImage *)image;

@end

@implementation SFLoadingImageItem

- (void)executeBlockForImage:(UIImage *)image {
    self.complitionBlock(image,self.link,[[NSDate date] timeIntervalSinceDate:self.dateAdded]);
}

@end

@interface SFDataAccessLayer ()

@property (nonatomic,strong) SFDataSource *dataSource;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic,strong) NSMutableDictionary *loadingImageStack;
@property (nonatomic,strong) NSCache *imageCache;

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *secret;


@end

@implementation SFDataAccessLayer

- (instancetype)initWithDataSource:(SFDataSource *)dataSource
           andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                               key:(NSString *)key
                            secret:(NSString *)secret {
    
    NSAssert(dataSource, @"data Source is required");
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.managedObjectContext = managedObjectContext;
        self.key = key;
        self.secret = secret;
    }
    return self;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSOperation *)getFeedForUser:(NSString *)user withComplitionBlock:(SFDataAccessLayerGetFeedComplitionBlock)complitionBlock {
    
    NSAssert(user,@"user is required");
    
    SFDataAccessLayerGetFeedComplitionBlock theComplitionBlock = [complitionBlock copy];
    __weak typeof(self) wself = self;
    
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
    __weak typeof(blockOperation) wblockOperation = blockOperation;
    

    //not main thread
    [blockOperation addExecutionBlock:^{
        
        __block NSError *theError;
        if (wblockOperation.cancelled) {
            return;
        }
        
        
        if (!wself.dataSource.isAutorized) {
            [wself.dataSource authorizeWithKey:self.key andSecret:self.secret complitionBlock:^(NSError *error) {
                if (error) {
                    theError = error;
                }
            }];
        }
        
        
        if (wblockOperation.cancelled) {
            return;
        }
        
        
        if (theError) {
            //Main Thread
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                theComplitionBlock(nil,theError);
            }];
            return;
        }
        
        [wself.dataSource getFeedForUser:user withComplitionBlock:^(NSArray *data, NSError *error) {
            
            if (wblockOperation.cancelled) {
                return;
            }
            //Main Thread
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                Timeline *timeline = nil;
                
                NSFetchRequest *request = [wself fetchRequestTimelineForUserName:user];
                NSError *theError;
                NSArray *objects = [wself.managedObjectContext executeFetchRequest:request error:&theError];
                if (!theError && objects.count > 0) {
                    timeline = [objects firstObject];
                }
                
                
                if (!error) {
                    
                    if (!timeline) {
                        timeline = [NSEntityDescription insertNewObjectForEntityForName:@"Timeline"
                                                                 inManagedObjectContext:wself.managedObjectContext];
                    }
                    timeline.screenName = user;
                    
                    
                    NSArray *allIdentifiers = [data valueForKeyPath:@"id.description"];
                    for (TwitterItem *object in timeline.twits) {
                        if (![allIdentifiers containsObject:object.identifier]) {
                            [wself.managedObjectContext deleteObject:object];
                        }
                    }
                    
                    NSArray *allExistIdentifiers = [timeline.twits valueForKeyPath:@"identifier"];

                    for (NSDictionary *twitData in data) {
                        NSString *identifier = [twitData[@"id"] description];
                        TwitterItem *twitterItem;
                        NSInteger index = [allExistIdentifiers indexOfObject:identifier];
                        
                        if (index == NSNotFound) {
                            twitterItem = [NSEntityDescription insertNewObjectForEntityForName:@"TwitterItem"
                                                                        inManagedObjectContext:wself.managedObjectContext];
                            twitterItem.timeline = timeline;
                        } else {
                            twitterItem = timeline.twits[index];
                        }
                        [twitterItem fillDataWithResponse:twitData];
                        
                    }
                    
                    [wself.managedObjectContext save:&theError];
                }
                
                
                theComplitionBlock(timeline,error);
            }];
            
        }];
    }];
    
    
    [self.queue addOperation:blockOperation];
    return blockOperation;
}

- (void)downloadImageWithLink:(NSString *)link complitionBlock:(DownloadImageComplitionBlock)complitionBlock {
    
    if (!self.imageCache) {
        self.imageCache = [[NSCache alloc] init];
    }
    
    
    UIImage *image = [self.imageCache objectForKey:link];
    if (image || !link) {
        complitionBlock(image,link,0);
        return;
    }
    
    if (!self.loadingImageStack) {
        self.loadingImageStack = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *listOfRequests = self.loadingImageStack[link];
    if (!listOfRequests) {
        listOfRequests = [NSMutableArray array];
        [self.loadingImageStack setValue:listOfRequests forKey:link];
    }
    
    SFLoadingImageItem *requestItem = [[SFLoadingImageItem alloc] init];
    requestItem.complitionBlock = complitionBlock;
    requestItem.dateAdded = [NSDate date];
    requestItem.link = link;
    
    if (listOfRequests.count == 0) {
        
        __weak typeof(self) wself = self;
        __weak NSMutableArray *theListOfRequests = listOfRequests;
        
        [self.queue addOperationWithBlock:^{
            
            NSURL *url = [NSURL URLWithString:link];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:[UIScreen mainScreen].scale
                                  orientation:image.imageOrientation];
            
            if (image) {
                [wself.imageCache setObject:image forKey:link];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (SFLoadingImageItem *request in theListOfRequests) {
                    [request executeBlockForImage:image];
                }
                [theListOfRequests removeAllObjects];
            }];
            
        }];
    }
    [listOfRequests addObject:requestItem];
}

- (NSFetchRequest *)fetchRequestTimelineForUserName:(NSString *)userName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Timeline"];
    request.predicate = [NSPredicate predicateWithFormat:@"screenName ==[c] %@",userName];
    return request;
}

- (NSFetchRequest *)fetchRequestTwitterItemForUserName:(NSString *)userName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TwitterItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"timeline.screenName =[c] %@",userName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO]];
    return request;
}

@end
