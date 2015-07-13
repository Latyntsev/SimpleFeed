//
//  SFViewController.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFDataAccessLayer;
@class AppDelegate;

@interface SFViewController : UIViewController

- (AppDelegate *)appDelegate;
- (SFDataAccessLayer *)dataAccessLayer;

@end
