//
//  Profile+FillData.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 7/14/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "Profile.h"

@interface Profile (FillData)

- (void)fillDataWithResponse:(NSDictionary *)responseData;

@end
