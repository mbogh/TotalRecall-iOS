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

#import <TUSafariActivity/TUSafariActivity.h>

@interface TORIncidentsViewController ()
@property (strong, nonatomic) TORIncidentsViewModel *viewModel;
@end

@implementation TORIncidentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LS(@"incidents.title");

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TORIncidentCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(TORIncidentCell.class)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TORIncident *incident = self.viewModel.incidents[indexPath.row];
    TORIncidentViewModel *incidentViewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    
    @weakify(self);
    [RACObserve(incidentViewModel, incidentURL) subscribeNext:^(id x) {
        @strongify(self);
        TUSafariActivity *activity = [[TUSafariActivity alloc] init];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[incident.title, x] applicationActivities:@[activity]];
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSegueWithIdentifier:@"TORIncidentViewControllerSegue" sender:incident];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TORIncidentViewControllerSegue"]) {
        ((TORIncidentViewController *)segue.destinationViewController).viewModel = [[TORIncidentViewModel alloc] initWithIncident:sender];
    }
}

@end
