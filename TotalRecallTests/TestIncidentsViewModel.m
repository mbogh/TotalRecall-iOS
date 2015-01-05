//
//  TestIncidentsViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 06/05/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

@import XCTest;

#import <Parse/Parse.h>
#import <OCMock/OCMock.h>
#import <Aspects/Aspects.h>
#import "TORIncidentsViewModel.h"

@interface TORIncidentsViewModel (Private)
- (void)fetchCachedIncidents;
@end

@interface TestIncidentsViewModel : XCTestCase

@end

@implementation TestIncidentsViewModel

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIfDownloadLatestIncidentsIsCalled {
    __block BOOL downloadLatestIncidentsCalled = NO;
    [TORIncidentsViewModel aspect_hookSelector:@selector(downloadLatestIncidents) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        downloadLatestIncidentsCalled = YES;
    } error:NULL];
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertFalse(downloadLatestIncidentsCalled, @"downloadLatestIncidents should not be called upon.");
    
    viewModel.active = YES;
    XCTAssertTrue(downloadLatestIncidentsCalled, @"downloadLatestIncidents should be called after being activated.");
}

- (void)testIfQueryIsCalled {
    __block BOOL queryCalled = NO;
    [TORIncidentsViewModel aspect_hookSelector:@selector(query) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        queryCalled = YES;
    } error:NULL];

    __unused TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertTrue(queryCalled, @"query should be called during init.");
}

- (void)testIfFetchCachedIncidentsIsCalled {
    __block BOOL fetchCachedIncidentsCalled = NO;
    [TORIncidentsViewModel aspect_hookSelector:@selector(fetchCachedIncidents) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        fetchCachedIncidentsCalled = YES;
    } error:NULL];

    __unused TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];

    XCTAssertTrue(fetchCachedIncidentsCalled, @"fetchCachedIncidentsCalled should be called during init.");
}

- (void)testIfIsLoadingIsBeingSetCorrectlyWhenDownloadingIncidents {
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertFalse(viewModel.isLoading, @"isLoading should be false until a download has been initiated.");
    
    [viewModel downloadLatestIncidents];
    XCTAssertTrue(viewModel.isLoading, @"isLoading should be true immediately after a download has been initiated.");
    
    __block BOOL findObjectsInBackgroundWithBlockCalled = NO;
    id mock = [OCMockObject mockForClass:[PFQuery class]];
    void (^completionBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        findObjectsInBackgroundWithBlockCalled = YES;
    };
    [[[mock stub] andDo:completionBlock] findObjectsInBackgroundWithBlock:[OCMArg any]];
//    viewModel.query = mock;
    [viewModel downloadLatestIncidents];
    XCTAssertTrue(findObjectsInBackgroundWithBlockCalled, @"findObjectsInBackgroundWithBlock completionBlock should be called or isLoading will never be false again.");
    [mock stopMocking];
}

- (void)testThatRegisterUserNotificationSettingsIsCalledWhenEnablingPush {
    __block BOOL registerUserNotificationSettingsCalled = NO;
    __block UIUserNotificationSettings *notificationSettingsCalled = nil;
    [UIApplication aspect_hookSelector:@selector(registerUserNotificationSettings:) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo, UIUserNotificationSettings *notificationSettings) {
        registerUserNotificationSettingsCalled = YES;
        notificationSettingsCalled = notificationSettings;
    } error:nil];

    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    viewModel.pushEnabled = YES;
    XCTAssertTrue(registerUserNotificationSettingsCalled, @"registerUserNotificationSettings: should be called when enabling push.");
    XCTAssertTrue(notificationSettingsCalled.types == UIUserNotificationTypeAlert, @"registerUserNotificationSettings: should be called with UIRemoteNotificationTypeAlert when enabling push.");
}

- (void)testThatRegisterForRemoteNotificationsIsCalledWhenEnablingPush {
    __block BOOL registerForRemoteNotificationsCalled = NO;
    [UIApplication aspect_hookSelector:@selector(registerForRemoteNotifications) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        registerForRemoteNotificationsCalled = YES;
    } error:nil];

    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    viewModel.pushEnabled = YES;
    XCTAssertTrue(registerForRemoteNotificationsCalled, @"registerForRemoteNotifications should be called when enabling push.");
}

- (void)testThatUnregisterForRemoteNotificationsIsCalledWhenDisablingPush {
    __block BOOL unregisterForRemoteNotificationsCalled = NO;
    [UIApplication aspect_hookSelector:@selector(unregisterForRemoteNotifications) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        unregisterForRemoteNotificationsCalled = YES;
    } error:nil];
    
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    viewModel.pushEnabled = NO;
    XCTAssertTrue(unregisterForRemoteNotificationsCalled, @"unregisterForRemoteNotificationsCalled should be called when disabling push.");
}

- (void)testPushFlagInUserDefaults {
    [NSUserDefaults resetStandardUserDefaults];
    [NSUserDefaults standardUserDefaults];
    
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertFalse(viewModel.isPushEnabled, @"Push should be disabled as default.");
    
    viewModel.pushEnabled = YES;
    XCTAssertTrue(viewModel.isPushEnabled, @"Push should be enabled after enabling it.");
    
    viewModel.pushEnabled = NO;
    XCTAssertFalse(viewModel.isPushEnabled, @"Push should be disabled after disabling it.");
}

@end
