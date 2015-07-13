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

- (void)setTwitterItem:(TwitterItem *)twitterItem forSizing:(BOOL)forSizing {
    
    self.nameLabel.text = twitterItem.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",twitterItem.screen_name];
    self.statusLabel.text = twitterItem.text;
    
    static NSDateFormatter *df;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
    }
    self.dateLabel.text = [df stringFromDate:twitterItem.created_at];
    self.logoImageView.image = nil;
    
    if (!forSizing) {
        __weak NSString *theLink = twitterItem.profile_image_url;
        __weak typeof(self) wself = self;
        [self.dataAccessLayer downloadImageWithLink:theLink complitionBlock:^(UIImage *image, NSString *link, NSTimeInterval loadingDuration) {
            if (![theLink isEqualToString:link]) {
                return;
            }
            if (loadingDuration > 0.05) {
                wself.logoImageView.alpha = 0;
                [UIView animateWithDuration:0.25 animations:^{
                    wself.logoImageView.alpha = 1;
                }];
            }
            
            wself.logoImageView.image = image;
            
        }];
    }

}

- (void)setTwitterItem:(TwitterItem *)twitterItem {
    
    [self setTwitterItem:twitterItem forSizing:NO];
}

- (void)setLogoImageView:(UIImageView *)logoImageView {
    _logoImageView = logoImageView;
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [[UIBezierPath bezierPathWithOvalInRect:logoImageView.bounds] CGPath];
    logoImageView.layer.mask = mask;
}

- (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (SFDataAccessLayer *)dataAccessLayer {
    return self.appDelegate.dataAccessLayer;
}

@end
