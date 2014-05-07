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
    [TORIncidentsViewModel aspect_hookSelector:@selector(downloadLatestIncidents) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^(id instance, NSArray *args) {
        downloadLatestIncidentsCalled = YES;
    } error:NULL];
    TORIncidentsViewModel *viewModel = [TORIncidentsViewModel new];
    XCTAssertFalse(downloadLatestIncidentsCalled, @"downloadLatestIncidents should not be called upon.");
    
    viewModel.active = YES;
    XCTAssertTrue(downloadLatestIncidentsCalled, @"downloadLatestIncidents should be called after being activated.");
}

- (void)testIfCachedIncidentsIsCalled {
    __block BOOL cachedIncidentsCalled = NO;
    [TORIncidentsViewModel aspect_hookSelector:@selector(cachedIncidents) withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval usingBlock:^(id instance, NSArray *args) {
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

@end
