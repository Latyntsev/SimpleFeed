//
//  Timeline.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Timeline : NSManagedObject

@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSOrderedSet *twits;
@end

@interface Timeline (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inTwitsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTwitsAtIndex:(NSUInteger)idx;
- (void)insertTwits:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTwitsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTwitsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceTwitsAtIndexes:(NSIndexSet *)indexes withTwits:(NSArray *)values;
- (void)addTwitsObject:(NSManagedObject *)value;
- (void)removeTwitsObject:(NSManagedObject *)value;
- (void)addTwits:(NSOrderedSet *)values;
- (void)removeTwits:(NSOrderedSet *)values;
@end
