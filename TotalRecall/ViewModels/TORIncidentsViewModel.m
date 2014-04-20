//
//  TORIncidentsViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentsViewModel.h"

#import "TORIncident.h"

@interface TORIncidentsViewModel ()
@property (strong, nonatomic) NSArray *incidents;
@end

@implementation TORIncidentsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        PFQuery *query = [PFQuery queryWithClassName:[TORIncident parseClassName]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.incidents = [objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO]]];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    return self;
}

@end
