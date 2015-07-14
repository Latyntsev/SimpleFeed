//
//  SFTimeLineBannerViewController.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 7/14/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFViewController.h"
@class Profile;

@interface SFTimeLineBannerViewController : SFViewController

@property (nonatomic,weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic,weak) IBOutlet UIImageView *gradientBackgroundView;
@property (nonatomic,weak) IBOutlet UIImageView *userImageView;
@property (nonatomic,weak) IBOutlet UILabel *locationLabel;
@property (nonatomic,weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic,weak) IBOutlet UIVisualEffectView *blureView;

- (void)setProfile:(Profile *)profile;

- (void)setLevel:(CGFloat)level;

@end
