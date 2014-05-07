//
//  TestIncidentViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 07/05/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TORIncident.h"
#import "TORIncidentViewModel.h"

@interface TORIncident (Private)
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@end

@interface TestIncidentViewModel : XCTestCase

@end

@implementation TestIncidentViewModel

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIncidentURL {
    TORIncident *incident = [TORIncident new];
    incident.url = @"http://example.com";
    TORIncidentViewModel *viewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    XCTAssertTrue([viewModel.incidentURL.absoluteString isEqualToString:incident.url], @"Constructed NSURL object must match incident URL.");
    
    incident.url = @"øå¨'2//example.com";
    viewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    XCTAssertTrue(viewModel.incidentURL, @"View Model always returns a non-nil NSURL Object.");
}

- (void)testIncidentTitle {
    TORIncident *incident = [TORIncident new];
    incident.title = @"Morten har fået dårlig mave!";
    TORIncidentViewModel *viewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    XCTAssertTrue([viewModel.title isEqualToString:incident.title], @"Title returned by View Model must match that of Incident.");
}

@end
