//
//  Profile.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TwitterItem;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * profileBannerURL;
@property (nonatomic, retain) NSString * profileImageURL;

@property (nonatomic, retain) NSOrderedSet *twits;
@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)insertObject:(TwitterItem *)value inTwitsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTwitsAtIndex:(NSUInteger)idx;
- (void)insertTwits:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTwitsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTwitsAtIndex:(NSUInteger)idx withObject:(TwitterItem *)value;
- (void)replaceTwitsAtIndexes:(NSIndexSet *)indexes withTwits:(NSArray *)values;
- (void)addTwitsObject:(TwitterItem *)value;
- (void)removeTwitsObject:(TwitterItem *)value;
- (void)addTwits:(NSOrderedSet *)values;
- (void)removeTwits:(NSOrderedSet *)values;
@end
