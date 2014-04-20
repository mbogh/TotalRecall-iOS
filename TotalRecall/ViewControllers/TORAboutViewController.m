//
//  TORAboutViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORAboutViewController.h"

@interface TORAboutViewController ()

@end

@implementation TORAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"about.title");
}

#pragma mark - Actions

- (IBAction)didTouchDoneButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
