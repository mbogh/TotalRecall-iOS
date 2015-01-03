//
//  TORIncidentViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewModel.h"
#import "TORIncident.h"

#import "UIColor+Hex.h"

@interface TORIncidentViewModel ()
@property (strong, nonatomic) TORIncident *incident;
@property (strong, nonatomic) NSString *content;
@end

@implementation TORIncidentViewModel

- (instancetype)initWithIncident:(TORIncident *)incident {
    self = [super init];
    if (self) {
        self.incident = incident;
        RAC(self, content) = [RACSignal combineLatest:@[ [RACObserve(self.incident, title) ignore:nil], [RACObserve(self.incident, summary) ignore:nil], [RACObserve(self.incident, content) ignore:nil] ] reduce:^id(NSString *title, NSString *summary, NSString *content) {
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"incident" ofType:@"html"];
            NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            return [NSString stringWithFormat:html, title, summary, content];
        }];
    }
    return self;
}

@end
