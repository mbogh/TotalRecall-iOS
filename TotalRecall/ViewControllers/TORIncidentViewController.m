//
//  TORIncidentViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewController.h"

#import "TORIncidentViewModel.h"

@interface TORIncidentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TORIncidentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    @weakify(self);
    [RACObserve(self.viewModel, content) subscribeNext:^(NSAttributedString *content) {
        @strongify(self);
        self.textView.attributedText = content;
    }];
}

@end
