//
//  TORIncidentViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewController.h"

#import "TORIncidentViewModel.h"

@import WebKit;

@interface TORIncidentViewController ()
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation TORIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, title) = RACObserve(self.viewModel, title);

    self.webView = [[WKWebView alloc] init];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    NSDictionary * views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    @weakify(self);
    [RACObserve(self.viewModel, content) subscribeNext:^(NSString *content) {
        @strongify(self);
        [self.webView loadHTMLString:content baseURL:nil];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
