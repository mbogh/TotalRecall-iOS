//
//  TORCase.h
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import <Parse/Parse.h>

@interface TORIncident : PFObject <PFSubclassing>
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSDate *publishedAt;
@property (nonatomic, readonly) NSDate *modifiedAt;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSString *summary;
+ (NSString *)parseClassName;
@end
