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
#import "SFConfiguration.h"

@interface SFTimeLineViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) Timeline *timeline;
@property (nonatomic,strong) CAGradientLayer *mask;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SFTimeLineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSFetchRequest *request = [self.dataAccessLayer fetchRequestTwitterItemForUserName:self.userName];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.dataAccessLayer.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    UIRefreshControl *refreshController = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshController];
    [refreshController addTarget:self action:@selector(refreshControlReloadData:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshControlReloadData:refreshController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.title = [NSString stringWithFormat:@"@%@",self.userName];
}

- (void)reloadData {
    
    [self.tableView reloadData];
}

#pragma mark - Actions

-(void)refreshControlReloadData:(UIRefreshControl *)refreshController {
    
    [refreshController beginRefreshing];
    __weak typeof(self) wself = self;
    [self.dataAccessLayer getFeedForUser:self.userName withComplitionBlock:^(Timeline *timeline, NSError *error) {
        
        [refreshController endRefreshing];
        wself.timeline = timeline;
        
        [wself reloadData];
        
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TwitterItem *twitterItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setTwitterItem:twitterItem forSizing:YES];
    CGSize size = [cell systemLayoutSizeFittingSize:(CGSize){tableView.frame.size.width,10}
                      withHorizontalFittingPriority:UILayoutPriorityRequired
                            verticalFittingPriority:UILayoutPriorityDefaultLow];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TwitterItem *twitterItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setTwitterItem:twitterItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TwitterItem *twitterItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (![self.userName isEqualToString:twitterItem.screen_name]) {
        SFTimeLineViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SFTimeLineViewController"];
        nextViewController.userName = twitterItem.screen_name;
        
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeMove) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    if (type == NSFetchedResultsChangeUpdate) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
