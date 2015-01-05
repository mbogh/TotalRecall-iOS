//
//  TestIncidentViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 07/05/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

@import XCTest;

#import "TORIncident.h"
#import "TORIncidentViewModel.h"

@interface TORIncident (Private)
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *summary;
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

- (void)testIncidentContent {
    TORIncident *incident = [TORIncident new];
    incident.content = @"http://example.com";
    incident.summary = @"";
    incident.title = @"";

    NSError *error = nil;
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"incident" ofType:@"html"];
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    XCTAssertNil(error, @"Error should be nil, else incident.html is missing from the project.");

    NSString *html = [NSString stringWithFormat:htmlTemplate, incident.title, incident.summary, incident.content];

    TORIncidentViewModel *viewModel = [[TORIncidentViewModel alloc] initWithIncident:incident];
    XCTAssertTrue([viewModel.content isEqualToString:html], @"Constructed NSURL object must match incident URL.");
}

@end
