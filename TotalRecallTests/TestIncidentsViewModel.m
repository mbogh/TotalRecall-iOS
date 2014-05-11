//
//  TestIncidentsViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 06/05/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <Aspects/Aspects.h>
#import "TORIncidentsViewModel.h"
#import <Parse/Parse.h>


@interface TORIncidentsViewModel (Private)
@property (strong, nonatomic) PFQuery *query;
- (NSArray *)cachedIncidents;
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

- (void)testIfCachedIncidentsIsCalled {
    __block BOOL cachedIncidentsCalled = NO;
    [TORIncidentsViewModel aspect_hookSelector:@selector(cachedIncidents) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^{
        cachedIncidentsCalled = YES;
    } error:NULL];
    __unused TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertTrue(cachedIncidentsCalled, @"cachedIncidents should be called during init.");
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
    viewModel.query = mock;
    [viewModel downloadLatestIncidents];
    XCTAssertTrue(findObjectsInBackgroundWithBlockCalled, @"findObjectsInBackgroundWithBlock completionBlock should be called or isLoading will never be false again.");
    [mock stopMocking];
}

- (void)testThatRegisterForRemoteNotificationTypesIsCalledWhenEnablingPush {
    __block BOOL registerForRemoteNotificationTypesCalled = NO;
    __block UIRemoteNotificationType notificationTypesCalled = -1;
    [UIApplication aspect_hookSelector:@selector(registerForRemoteNotificationTypes:) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo, UIRemoteNotificationType notificationTypes) {
        registerForRemoteNotificationTypesCalled = YES;
        notificationTypesCalled = notificationTypes;
    } error:nil];
    
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    viewModel.pushEnabled = YES;
    XCTAssertTrue(registerForRemoteNotificationTypesCalled, @"registerForRemoteNotificationTypes: should be called when enabling push.");
    XCTAssertTrue(notificationTypesCalled == UIRemoteNotificationTypeAlert, @"registerForRemoteNotificationTypes: should be called with UIRemoteNotificationTypeAlert when enabling push.");
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
