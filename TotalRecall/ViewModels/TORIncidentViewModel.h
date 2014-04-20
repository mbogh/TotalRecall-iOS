//
//  TORIncidentViewModel.h
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "RVMViewModel.h"

@class TORIncident;
@interface TORIncidentViewModel : RVMViewModel
@property (strong, readonly, nonatomic) TORIncident *incident;
@property (strong, readonly, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) NSURL *incidentURL;
- (instancetype)initWithIncident:(TORIncident *)incident;
@end
