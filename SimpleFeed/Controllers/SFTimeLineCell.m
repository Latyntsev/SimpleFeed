//
//  SFTimeLineCell.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFTimeLineCell.h"
#import "SFModel.h"

@implementation SFTimeLineCell

- (void)setTwitterItem:(TwitterItem *)twitterItem {
    
    self.nameLabel.text = twitterItem.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",twitterItem.screen_name];
    self.statusLabel.text = twitterItem.text;
    
    static NSDateFormatter *df;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
    }
    self.dateLabel.text = [df stringFromDate:twitterItem.created_at];
    
}

@end
