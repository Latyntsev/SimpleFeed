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

NSString *const key = @"hws3MrA6qCOp0Mc9o0BgxA";
NSString *const secret = @"6yAbeJXiRLhzyfTAYn11n3oqxne9FxWWn5JQvzZl0Tc";

@interface SFDataAccessLayer ()

@property (nonatomic,strong) SFDataSource *dataSource;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation SFDataAccessLayer

- (instancetype)initWithDataSource:(SFDataSource *)dataSource andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSAssert(dataSource, @"data Source is required");
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.managedObjectContext = managedObjectContext;
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
    user = [user lowercaseString];
    
    SFDataAccessLayerGetFeedComplitionBlock theComplitionBlock = [complitionBlock copy];
    __weak typeof(self) wself = self;
    
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
    __weak typeof(blockOperation) wblockOperation = blockOperation;
    
    
    __block Timeline *timeline;
    if (self.managedObjectContext) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Timeline"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"screenName == %@",user];
        request.predicate = predicate;
        
        NSError *error;
        NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (!error && objects.count > 0) {
            timeline = [objects firstObject];
            theComplitionBlock(timeline, error, SFResponseStatus_cachedData);
        }
    }
    
    
    
    
    //not main thread
    [blockOperation addExecutionBlock:^{
        
        __block NSError *theError;
        if (wblockOperation.cancelled) {
            return;
        }
        
        
        if (!wself.dataSource.isAutorized) {
            [wself.dataSource authorizeWithKey:key andSecret:secret complitionBlock:^(NSError *error) {
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
                theComplitionBlock(nil,theError,SFResponseStatus_finalResponse);
            }];
            return;
        }
        
        [wself.dataSource getFeedForUser:user withComplitionBlock:^(NSArray *data, NSError *error) {
            
            //Main Thread
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                if (!error) {
                    if (!timeline) {
                        timeline = [NSEntityDescription insertNewObjectForEntityForName:@"Timeline"
                                                                 inManagedObjectContext:wself.managedObjectContext];
                        timeline.screenName = user;
                    } else {
                        for (TwitterItem *object in timeline.twits) {
                            
                            [wself.managedObjectContext deleteObject:object];
                        }
                    }

                    for (NSDictionary *twitData in data) {
                        TwitterItem *twitterItem = [NSEntityDescription insertNewObjectForEntityForName:@"TwitterItem"
                                                                                 inManagedObjectContext:wself.managedObjectContext];
                        [twitterItem fillDataWithResponse:twitData];
                        twitterItem.timeline = timeline;
                    }
                    
                    [wself.managedObjectContext save:&theError];
                }
                
                if (wblockOperation.cancelled) {
                    return;
                }
                
                theComplitionBlock(timeline,error,SFResponseStatus_finalResponse);
            }];
            
        }];
    }];
    
    
    [self.queue addOperation:blockOperation];
    return blockOperation;
}

@end
