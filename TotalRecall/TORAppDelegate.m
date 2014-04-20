//
//  TORAppDelegate.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORAppDelegate.h"

#import <Parse/Parse.h>
#import "TORIncident.h"

@implementation TORAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParseWithOptions:launchOptions];
    
    [self applyAppearance];
    
    return YES;
}

#pragma mark - Parse

- (void)setupParseWithOptions:(NSDictionary *)launchOptions {
    [TORIncident registerSubclass];
    [Parse setApplicationId:@"BfjCrISj7ZfOvYs9XAH7wBZNNPzVNwr3v2t0PuXp" clientKey:@"Z4LKOwj9dtDWNVDqRlObpbqMBGCYvxPY3tMitGeR"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

#pragma mark - Appearance

- (void)applyAppearance {
    [UINavigationBar appearance].barTintColor = [UIColor colorWithHexString:@"0BD318"];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
}

@end
