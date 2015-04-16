//
//  SFTimeLineViewController.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFTimeLineViewController.h"
#import "SFDataAccessLayer.h"
#import "Timeline.h"


@interface SFTimeLineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) Timeline *timeline;

@end

@implementation SFTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.userName) {
        self.userName = @"dubizzle";
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLoadingProgress:YES];
    self.title = [NSString stringWithFormat:@"@%@",self.userName];
    __weak typeof(self) wself = self;
    
    [self.dataAccessLayer getFeedForUser:self.userName withComplitionBlock:^(Timeline *timeline, NSError *error, SFResponseStatus responseStatus) {
        [wself showLoadingProgress:NO];
        wself.timeline = timeline;
        
        [wself reloadData];
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeline.twits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
