//
//  TORIncidentViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewController.h"

#import "TORIncidentViewModel.h"

#import "TORIncident.h"

#import <TUSafariActivity.h>
#import <ARChromeActivity.h>

@import WebKit;

@interface TORIncidentViewController ()
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation TORIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";

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

    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
        ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
        NSArray *activities = @[safariActivity, chromeActivity];
        TORIncident *incident = self.viewModel.incident;
        NSURL *url = [NSURL URLWithString:[incident.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[incident.title, incident.summary, url] applicationActivities:activities];
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        [self presentViewController:activityViewController animated:YES completion:nil];
        return [RACSignal empty];
    }];

    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

@end
