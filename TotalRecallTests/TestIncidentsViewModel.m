//
//  TestIncidentsViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 06/05/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Aspects/Aspects.h>
#import "TORIncidentsViewModel.h"

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
    XCTAssertFalse(downloadLatestIncidentsCalled, @"downloadLatestIncidents should not be called upon");
    
    viewModel.active = YES;
    XCTAssertTrue(downloadLatestIncidentsCalled, @"downloadLatestIncidents should be called after being activated.");
}

@end
