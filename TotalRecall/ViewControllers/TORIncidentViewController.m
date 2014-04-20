//
//  TORIncidentViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewController.h"

#import "TORIncidentViewModel.h"

@interface TORIncidentViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TORIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    @weakify(self);
    [RACObserve(self.viewModel, incidentURL) subscribeNext:^(id x) {
        @strongify(self);
        [self.webView loadRequest:[NSURLRequest requestWithURL:x]];
    }];
}

#pragma mark - UIWebViewDelegate

@end
