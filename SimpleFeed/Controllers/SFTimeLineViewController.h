//
//  SFTimeLineViewController.h
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFViewController.h"

@interface SFTimeLineViewController : SFViewController

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,weak) IBOutlet UITableView *tableView;

@end
