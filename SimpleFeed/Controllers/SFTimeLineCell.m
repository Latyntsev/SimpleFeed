//
//  SFTimeLineCell.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFTimeLineCell.h"
#import "SFModel.h"
#import "AppDelegate.h"
#import "SFDataAccessLayer.h"

@implementation SFTimeLineCell

- (void)setTwitterItem:(TwitterItem *)twitterItem {

    _twitterItem = twitterItem;
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

- (void)setLogoImageView:(UIImageView *)logoImageView {
    _logoImageView = logoImageView;
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [[UIBezierPath bezierPathWithOvalInRect:logoImageView.bounds] CGPath];
    logoImageView.layer.mask = mask;
}

@end
