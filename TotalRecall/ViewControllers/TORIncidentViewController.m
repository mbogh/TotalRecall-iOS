//
//  TORIncidentViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewController.h"

#import "TORIncident.h"

@interface TORIncidentViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TORIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.incident.title;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.incident.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

@end
