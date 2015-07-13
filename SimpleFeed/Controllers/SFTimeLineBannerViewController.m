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

@implementation SFTimeLineBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationLabel.text = @"";
    self.descriptionLabel.text = @"";
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
        
        if (!isCacheValue) {
            self.backgroundImageView.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.backgroundImageView.alpha = 1;
            }];
        }
        
    }];
    
    [self.dataAccessLayer downloadImageWithLink:profile.profileImageURL complitionBlock:^(UIImage *image, NSString *link, BOOL isCacheValue) {
        self.userImageView.image = image;
    }];

}

- (void)setLevel:(CGFloat)level {
    
    self.userImageView.alpha = level * 2;
    
}

@end
