//
//  TORAppDelegate.h
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

@import UIKit;

@interface TORAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Notifications
- (void)enableNotificationsForApplication:(UIApplication *)application;

@end
