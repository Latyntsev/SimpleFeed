//
//  SFTimeLineCell.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterItem;

@interface SFTimeLineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setTwitterItem:(TwitterItem *)twitterItem;
- (void)setTwitterItem:(TwitterItem *)twitterItem forSizing:(BOOL)forSizing;

@end
