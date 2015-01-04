//
//  TORCase.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncident.h"

@implementation TORIncident
@dynamic title, url, publishedAt, modifiedAt, content, summary;

#pragma mark - PFSubclassing

+ (NSString *)parseClassName; {
    return @"Incident";
}

@end
