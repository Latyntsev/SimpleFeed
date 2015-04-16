//
//  SFTimeLineViewController.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 4/16/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFTimeLineViewController.h"
#import "SFTimeLineCell.h"
#import "SFDataAccessLayer.h"
#import "SFModel.h"


@interface SFTimeLineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) Timeline *timeline;
@property (nonatomic,strong) CAGradientLayer *mask;
@end

@implementation SFTimeLineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (!self.userName) {
        self.userName = @"dubizzle";
    }
    
    self.mask = [CAGradientLayer layer];
    
    self.mask.frame = self.view.frame;
    self.mask.colors = [NSArray arrayWithObjects:
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor clearColor].CGColor,
                        (id)[UIColor clearColor].CGColor, nil];
    self.mask.locations = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.7f],
                           [NSNumber numberWithFloat:0.88],
                           [NSNumber numberWithFloat:1], nil];
    
    self.mask.startPoint = CGPointZero;
    self.mask.endPoint = CGPointMake(0, 1);
    
    
    self.contentView.layer.mask = self.mask;

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
    
    UIView *view = [self.tableView snapshotViewAfterScreenUpdates:NO];
    view.center = self.tableView.center;
    [self.tableView.superview addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 0;
        view.frame = CGRectInset(view.frame, -20, -20);
        view.center = self.tableView.center;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeline.twits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TwitterItem *twitterItem = [self.timeline.twits objectAtIndex:indexPath.row];
    [cell setTwitterItem:twitterItem forSizing:YES];
    CGSize size = [cell systemLayoutSizeFittingSize:(CGSize){tableView.frame.size.width,10}
                      withHorizontalFittingPriority:UILayoutPriorityRequired
                            verticalFittingPriority:UILayoutPriorityDefaultLow];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TwitterItem *twitterItem = [self.timeline.twits objectAtIndex:indexPath.row];
    [cell setTwitterItem:twitterItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TwitterItem *twitterItem = [self.timeline.twits objectAtIndex:indexPath.row];
    if (![self.userName isEqualToString:twitterItem.screen_name]) {
        SFTimeLineViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SFTimeLineViewController"];
        nextViewController.userName = twitterItem.screen_name;
        
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

@end
