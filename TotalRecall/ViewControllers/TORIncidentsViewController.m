//
//  TORViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentsViewController.h"
#import "TORIncidentViewController.h"

#import "TORIncidentsViewModel.h"
#import "TORIncidentViewModel.h"
#import "TORIncident.h"

#import "TORIncidentCell.h"

@interface TORIncidentsViewController () <UISplitViewControllerDelegate>
@property (strong, nonatomic) TORIncidentsViewModel *viewModel;
@property (assign, nonatomic) BOOL shouldCollapseDetailViewController;
@end

@implementation TORIncidentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LS(@"incidents.title");

    self.shouldCollapseDetailViewController = YES;
    self.splitViewController.delegate = self;

    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    @weakify(self);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIRefreshControl *refreshControl) {
        if (refreshControl.isRefreshing) {
            @strongify(self);
            [self.viewModel downloadLatestIncidents];
        }
    }];
    
    self.viewModel = [TORIncidentsViewModel new];
    [RACObserve(self.viewModel, incidents) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *isLoading) {
        @strongify(self);
        if (isLoading.boolValue) {
            [self.refreshControl beginRefreshing];
            if (self.tableView.contentOffset.y == -64.f) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
            }
        }
        else {
            [self.refreshControl endRefreshing];
        }
    }];
    
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.viewModel.pushTitle
                                                                 delegate:nil
                                                        cancelButtonTitle:LS(@"incidents.push.actionsheet.cancel")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:self.viewModel.pushAction, nil];
        
        [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            if (actionSheet.cancelButtonIndex != buttonIndex.integerValue) {
                self.viewModel.pushEnabled = !self.viewModel.isPushEnabled;
            }
        }];
        [actionSheet showInView:self.view];
        return [RACSignal empty];
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.viewModel.isActive) {
        self.viewModel.active = YES;
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:TORDefaultsLastSyncDate] timeIntervalSinceNow] > 1.f*60.f*60.f) {
        [self.viewModel downloadLatestIncidents];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.incidents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TORIncidentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TORIncidentCell.class) forIndexPath:indexPath];
    TORIncident *incident = self.viewModel.incidents[indexPath.row];
    [cell configureWithIncident:incident];
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return self.shouldCollapseDetailViewController;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TORIncidentViewControllerSegue"]) {
        self.shouldCollapseDetailViewController = NO;

        TORIncidentCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        TORIncident *incident = self.viewModel.incidents[indexPath.row];
        UINavigationController *navigationCotrller = segue.destinationViewController;
        ((TORIncidentViewController *)navigationCotrller.topViewController).viewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    }
}

@end
