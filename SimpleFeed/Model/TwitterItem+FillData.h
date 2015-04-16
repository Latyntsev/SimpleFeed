//
//  TwitterItem+FillData.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "TwitterItem.h"

@interface TwitterItem (FillData)

- (void)fillDataWithResponse:(NSDictionary *)responseData;

@end
