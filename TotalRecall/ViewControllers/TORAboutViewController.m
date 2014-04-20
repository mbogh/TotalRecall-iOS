//
//  TORAboutViewController.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORAboutViewController.h"

@interface TORAboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation TORAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"about.title");
    self.nameLabel.text = LS(@"about.name");
    self.descriptionLabel.text = LS(@"about.description");
}

#pragma mark - Actions

- (IBAction)didTouchDoneButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
