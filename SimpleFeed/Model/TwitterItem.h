//
//  TwitterItem.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Timeline;

@interface TwitterItem : NSManagedObject

@property (nonatomic, retain) Timeline *timeline;

@end
