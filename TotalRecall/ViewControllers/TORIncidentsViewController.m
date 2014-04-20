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

@interface TORIncidentsViewController ()
@property (strong, nonatomic) TORIncidentsViewModel *viewModel;
@end

@implementation TORIncidentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"incidents.title");
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TORIncidentCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(TORIncidentCell.class)];
    self.tableView.tableFooterView = [UIView new];
    
    self.viewModel = [TORIncidentsViewModel new];
    @weakify(self);
    [RACObserve(self.viewModel, incidents) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
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
    [self performSegueWithIdentifier:@"TORIncidentViewControllerSegue" sender:incident];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TORIncidentViewControllerSegue"]) {
        ((TORIncidentViewController *)segue.destinationViewController).viewModel = [[TORIncidentViewModel alloc] initWithIncident:sender];
    }
}

@end
