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
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@end

@implementation TORIncidentViewModel

- (instancetype)initWithIncident:(TORIncident *)incident {
    self = [super init];
    if (self) {
        self.incident = incident;
        
        RAC(self, title) = RACObserve(self.incident, title);
        RAC(self, content) = RACObserve(self.incident, content);
    }
    return self;
}

@end
