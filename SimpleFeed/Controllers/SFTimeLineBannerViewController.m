//
//  SFTimeLineBannerViewController.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 7/14/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFTimeLineBannerViewController.h"
#import "SFDataAccessLayer.h"
#import "SFModel.h"

@interface SFTimeLineBannerViewController ()

@property (nonatomic) CGFloat level;

@end

@implementation SFTimeLineBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationLabel.text = @"";
    self.descriptionLabel.text = @"";
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.frame = self.gradientBackgroundView.bounds;
    
    gradient.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.8].CGColor];
    gradient.locations = @[@0.0, @1];
    [self.gradientBackgroundView.layer addSublayer:gradient];
}

- (void)setProfile:(Profile *)profile {
    
    
    self.locationLabel.text = profile.location;
    self.descriptionLabel.text = profile.descr;
    
    NSString *profileBannerURL = profile.profileBannerURL;
    if (profileBannerURL.length == 0) {
        profileBannerURL = profile.profileImageURL;
    }
    
    [self.dataAccessLayer downloadImageWithLink:profileBannerURL complitionBlock:^(UIImage *image, NSString *link, BOOL isCacheValue) {
        self.backgroundImageView.image = image;
        self.gradientBackgroundView.image = image;
        if (!isCacheValue) {
            self.backgroundImageView.alpha = 0;
            self.gradientBackgroundView.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.backgroundImageView.alpha = 1;
                self.gradientBackgroundView.alpha = 1;
                [self levelUpdated];
            }];
        }
        
    }];
    
    self.userImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.dataAccessLayer downloadImageWithLink:profile.profileImageURL complitionBlock:^(UIImage *image, NSString *link, BOOL isCacheValue) {
        self.userImageView.image = image;
        
        if (!isCacheValue) {
            [UIView animateWithDuration:0.25 animations:^{
                self.userImageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        } else {
            self.userImageView.transform = CGAffineTransformMakeScale(1, 1);
        }
    }];

}

- (void)setLevel:(CGFloat)level {
    _level = level;
    
    [self levelUpdated];
}

- (void)levelUpdated {
    
    self.userImageView.alpha = self.level * 2;
    self.gradientBackgroundView.alpha = self.level * 2;
    
    CGFloat value = MAX((self.level * 4 - 3),0);
    self.locationLabel.alpha = value;
    self.descriptionLabel.alpha = value;
}

@end
