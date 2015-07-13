//
//  TwitterItem.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface TwitterItem : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * favorite_count;
@property (nonatomic, retain) NSNumber * retweet_count;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Profile *profile;

@end
