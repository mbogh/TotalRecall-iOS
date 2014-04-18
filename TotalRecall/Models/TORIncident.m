//
//  TORCase.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncident.h"
#import <Parse/PFObject+Subclass.h>

@implementation TORIncident
@dynamic title, link, publishedAt;

//#pragma mark - Properties
//
//- (NSString *)title {
//    return self[@"title"];
//}
//
//- (NSString *)link {
//    return self[@"link"];
//}
//
//- (NSDate *)date {
//    return self[@"publishedAt"];
//}

#pragma mark - PFSubclassing

+ (NSString *)parseClassName; {
    return @"Incident";
}

@end
