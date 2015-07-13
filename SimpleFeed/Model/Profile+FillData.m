//
//  Profile+FillData.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 7/14/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "Profile+FillData.h"

@implementation Profile (FillData)

- (void)fillDataWithResponse:(NSDictionary *)responseData {
    self.descr = responseData[@"description"];
    self.location = responseData[@"location"];
    self.profileImageURL = responseData[@"profile_image_url"];
    self.profileBannerURL = responseData[@"profile_banner_url"];
}

@end
