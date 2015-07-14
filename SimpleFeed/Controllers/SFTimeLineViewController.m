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
#import "SFTimeLineBannerViewController.h"

@interface SFTimeLineViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) CAGradientLayer *mask;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewBottomMarginConstraint;
@property (nonatomic,strong) SFTimeLineBannerViewController *topBannerViewController;

@end

@implementation SFTimeLineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    NSFetchRequest *profileRequest = [self.dataAccessLayer fetchRequestProfileByUserName:self.userName];
    NSError *theError;
    NSArray *objects = [self.dataAccessLayer.managedObjectContext executeFetchRequest:profileRequest error:&theError];
    if (!theError && objects.count > 0) {
        Profile *profile = [objects firstObject];
        [self.topBannerViewController setProfile:profile];
    }

    
    
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
    
    [refreshController beginRefreshing];
    [self refreshControlReloadData:refreshController];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topBannerMainView.frame.size.height, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.title = [NSString stringWithFormat:@"@%@",self.userName];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)reloadData {
    
    [self.tableView reloadData];
}

#pragma mark - Actions

-(void)refreshControlReloadData:(UIRefreshControl *)refreshController {
    
    __weak typeof(self) wself = self;
    [self.dataAccessLayer getFeedForUser:self.userName withComplitionBlock:^(Profile *profile, NSError *error) {
        
        [refreshController endRefreshing];
        [wself.topBannerViewController setProfile:profile];
        [wself reloadData];
    
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"SFTimeLineBannerViewController"]) {
        self.topBannerViewController = segue.destinationViewController;
    }
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
    [cell setTwitterItem:twitterItem];
    CGSize size = [cell systemLayoutSizeFittingSize:(CGSize){tableView.frame.size.width,10}
                      withHorizontalFittingPriority:UILayoutPriorityRequired
                            verticalFittingPriority:UILayoutPriorityDefaultLow];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TwitterItem *twitterItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setTwitterItem:twitterItem];
    
    cell.logoImageView.image = nil;
    
    NSString *theLink = twitterItem.profile_image_url;
    __weak typeof(cell) wcell = cell;
    [self.dataAccessLayer downloadImageWithLink:theLink complitionBlock:^(UIImage *image, NSString *link, BOOL isCacheValue) {
        if (![cell.twitterItem.profile_image_url isEqualToString:link]) {
            return;
        }
        if (!isCacheValue) {
            
            wcell.logoImageView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.1, 0.1), M_PI );
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:0 animations:^{
                wcell.logoImageView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:nil];
        }
        
        wcell.logoImageView.image = image;
        
    }];
    
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

#pragma mark - UIScrolViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat value = scrollView.contentOffset.y + scrollView.contentInset.top;
    self.infoViewBottomMarginConstraint.constant = MAX(value,0);
    CGFloat level = (self.topBannerViewController.view.frame.size.height - 64) / scrollView.contentInset.top;
    
    [self.topBannerViewController setLevel:MIN(MAX(level,0),1)];
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
