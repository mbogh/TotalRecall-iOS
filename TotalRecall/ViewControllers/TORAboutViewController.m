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
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@end

@implementation TORAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"about.title");
    [self.twitterButton setTitle:LS(@"about.twitter") forState:UIControlStateNormal];
    [self.twitterButton setTitleColor:TORBlackTextColor forState:UIControlStateNormal];
    
    NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:LS(@"about.description")];
    [descriptionString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:nil] atIndex:descriptionString.length];
    
    [descriptionString insertAttributedString:[[NSAttributedString alloc] initWithString:LS(@"about.version.title") attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:self.descriptionLabel.font.pointSize]}] atIndex:descriptionString.length];
    
    [descriptionString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil] atIndex:descriptionString.length];
    
    [descriptionString insertAttributedString:[[NSAttributedString alloc] initWithString:LS(@"about.version.description") attributes:nil] atIndex:descriptionString.length];
    
    self.descriptionLabel.attributedText = descriptionString;
    self.descriptionLabel.textColor = TORGreyTextColor;
}

#pragma mark - Actions

- (IBAction)didTouchDoneButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchTwitterButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/mbogh"]];
}

@end
