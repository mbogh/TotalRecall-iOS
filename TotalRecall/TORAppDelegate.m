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

NSString *const TORNotificationCategoryShow = @"TORNotificationCategoryShow";
NSString *const TORNotificationCategoryShowAction= @"TORNotificationCategoryShowAction";

@implementation TORAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"91cee469acb56fb41becc68f4429e6c5bd9ba669"];
    [self setupParseWithOptions:launchOptions];
    [self setupParseAnalytics];
    [self applyAppearance];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{TORDefaultsPushMessage: @(NO), TORDefaultsLastSyncDate: [NSDate dateWithTimeIntervalSince1970:0]}];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:TORDefaultsPushMessage]) {
        [self enableNotificationsForApplication:application];
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

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:TORNotificationCategoryShowAction]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://usn.dk"]];
    }
    completionHandler();
}

#pragma mark - Parse

- (void)setupParseWithOptions:(NSDictionary *)launchOptions {
    [TORIncident registerSubclass];
    [Parse enableLocalDatastore];
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

#pragma mark - Notifications

- (void)enableNotificationsForApplication:(UIApplication *)application
{
    UIMutableUserNotificationAction *showAction = [[UIMutableUserNotificationAction alloc] init];
    showAction.identifier = TORNotificationCategoryShowAction;
    showAction.title = LS(@"notification.action.show");
    showAction.activationMode = UIUserNotificationActivationModeForeground;
    showAction.destructive = YES;
    showAction.authenticationRequired = YES;

    UIMutableUserNotificationCategory *showActionsCategory = [[UIMutableUserNotificationCategory alloc] init];
    showActionsCategory.identifier = TORNotificationCategoryShow;
    [showActionsCategory setActions:@[showAction] forContext:UIUserNotificationActionContextDefault];
    [showActionsCategory setActions:@[showAction] forContext:UIUserNotificationActionContextMinimal];

    UIUserNotificationSettings *currentNotifSettings = application.currentUserNotificationSettings;
    UIUserNotificationType notificationTypes = currentNotifSettings.types;
    if (notificationTypes == UIUserNotificationTypeNone) {
        notificationTypes = UIUserNotificationTypeAlert;
    }

    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:notificationSettings];
    [application registerForRemoteNotifications];
}

@end
