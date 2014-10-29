//
//  TORAppDelegate.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORAppDelegate.h"

#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import <Aspects/Aspects.h>

#import "TORIncident.h"

@implementation TORAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"91cee469acb56fb41becc68f4429e6c5bd9ba669"];
    [self setupParseWithOptions:launchOptions];
    [self setupParseAnalytics];
    [self applyAppearance];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TORDefaultsPushMessage: @(NO), TORDefaultsLastSyncDate: [NSDate dateWithTimeIntervalSince1970:0]}];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:TORDefaultsPushMessage]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:@"active" forKey:@"channels"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - Parse

- (void)setupParseWithOptions:(NSDictionary *)launchOptions {
    [TORIncident registerSubclass];
    [Parse setApplicationId:@"BfjCrISj7ZfOvYs9XAH7wBZNNPzVNwr3v2t0PuXp" clientKey:@"Z4LKOwj9dtDWNVDqRlObpbqMBGCYvxPY3tMitGeR"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (void)setupParseAnalytics {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        UIViewController *viewController = aspectInfo.instance;
        if (viewController.title && viewController.title.length > 0) {
            [PFAnalytics trackEvent:TORAnalyticsEventViewWillAppear dimensions:@{@"Title": viewController.title}];
        }
    } error:nil];
}

#pragma mark - Appearance

- (void)applyAppearance {
    [UINavigationBar appearance].tintColor = [UIColor colorWithHexString:@"ff5b37"];
}

@end
