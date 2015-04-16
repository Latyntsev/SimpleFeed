//
//  SFViewController.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFViewController.h"
#import "SFLoadingProgressViewController.h"

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
        [self.storyboard instantiateViewControllerWithIdentifier:@"SFLoadingProgressViewController"];
    }
}

@end
