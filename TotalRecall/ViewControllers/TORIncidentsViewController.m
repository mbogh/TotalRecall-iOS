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

@interface TORIncidentsViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) TORIncidentsViewModel *viewModel;
@property (strong, nonatomic) TORIncidentCell *incidentCell;
@end

@implementation TORIncidentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LS(@"incidents.title") uppercaseString];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TORIncidentCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(TORIncidentCell.class)];
    self.tableView.tableFooterView = [UIView new];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIRefreshControl *refreshControl) {
        if (refreshControl.isRefreshing) {
            [self.viewModel downloadLatestIncidents];
        }
    }];
    
    self.incidentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TORIncidentCell class]) owner:nil options:nil] firstObject];
    
    self.viewModel = [TORIncidentsViewModel new];
    @weakify(self);
    [RACObserve(self.viewModel, incidents) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *x) {
        BOOL isLoading = x.boolValue;
        if (isLoading) {
            [self.refreshControl beginRefreshing];
            if (self.tableView.contentOffset.y == -64.f) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
            }
        }
        else {
            [self.refreshControl endRefreshing];
        }
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

#pragma mark - Actions

- (IBAction)didTouchPushSettingButton:(UIBarButtonItem *)sender {
    NSString *title, *action;
    if (self.viewModel.isPushEnabled) {
        title = LS(@"incidents.push.actionsheet.disable.title");
        action = LS(@"incidents.push.actionsheet.disable");
    }
    else {
        title = LS(@"incidents.push.actionsheet.enable.title");
        action = LS(@"incidents.push.actionsheet.enable");
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:LS(@"incidents.push.actionsheet.cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:action, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (self.viewModel.isPushEnabled) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
        else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
        }
        self.viewModel.pushEnabled = !self.viewModel.isPushEnabled;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TORIncident *incident = self.viewModel.incidents[indexPath.row];
    TORIncidentViewModel *incidentViewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    
    [RACObserve(incidentViewModel, incidentURL) subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:x];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSegueWithIdentifier:@"TORIncidentViewControllerSegue" sender:incident];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.f;
    TORIncident *incident = self.viewModel.incidents[indexPath.row];
    [self.incidentCell configureWithIncident:incident];
    [self.incidentCell setNeedsUpdateConstraints];
    [self.incidentCell updateConstraintsIfNeeded];
    
    self.incidentCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.incidentCell.bounds));
    [self.incidentCell setNeedsLayout];
    [self.incidentCell layoutIfNeeded];
    
    rowHeight = [self.incidentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    rowHeight += 1.0f;
    return rowHeight;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TORIncidentViewControllerSegue"]) {
        ((TORIncidentViewController *)segue.destinationViewController).viewModel = [[TORIncidentViewModel alloc] initWithIncident:sender];
    }
}

@end
