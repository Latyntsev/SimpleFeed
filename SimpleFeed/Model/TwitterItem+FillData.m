//
//  TwitterItem+FillData.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "TwitterItem+FillData.h"

@implementation TwitterItem (FillData)

- (void)fillDataWithResponse:(NSDictionary *)responseData {
    
    static NSDateFormatter *df;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"EEE MMM dd HH:mm:ss +zzzz yyyy";
    }
    self.created_at = [df dateFromString:responseData[@"created_at"]];
    self.text = responseData[@"text"];
    self.favorite_count = responseData[@"favorite_count"];
    self.retweet_count = responseData[@"retweet_count"];
    
    NSDictionary *userData = responseData[@"retweeted_status"][@"user"];
    if (!userData) {
        userData = responseData[@"user"];
    }
    
    self.name = userData[@"name"];
    self.screen_name = userData[@"screen_name"];
    self.profile_image_url = userData[@"profile_image_url"];
    
}

@end
