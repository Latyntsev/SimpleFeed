//
//  SFViewController.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFViewController.h"
#import "SFLoadingProgressViewController.h"
#import "AppDelegate.h"

@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showLoadingProgress:(BOOL)show {
    
    static SFLoadingProgressViewController *loadingProgressViewController;
    if (!loadingProgressViewController) {
        loadingProgressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SFLoadingProgressViewController"];
        loadingProgressViewController.view.alpha = 0;
    }
    if (show) {
        [self addChildViewController:loadingProgressViewController];
        [self.view addSubview:loadingProgressViewController.view];
        [UIView animateWithDuration:0.25 animations:^{
            loadingProgressViewController.view.alpha = 1;
        }];
        self.view.userInteractionEnabled = NO;
    } else {
        if (loadingProgressViewController.parentViewController == self) {
            [loadingProgressViewController removeFromParentViewController];
            [UIView animateWithDuration:0.25 animations:^{
                loadingProgressViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                [loadingProgressViewController.view removeFromSuperview];
            }];
            
        }
        self.view.userInteractionEnabled = YES;
    }
}

- (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (SFDataAccessLayer *)dataAccessLayer {
    return self.appDelegate.dataAccessLayer;
}

@end
