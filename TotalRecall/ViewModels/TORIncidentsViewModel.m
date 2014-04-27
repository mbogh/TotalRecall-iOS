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
@property (assign, nonatomic, getter = isLoading) BOOL loading;
@end

@implementation TORIncidentsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.incidents = [self cachedIncidents];
        self.loading = NO;
        
        @weakify(self);
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self downloadLatestIncidents];
        }];
    }
    return self;
}

#pragma mark - Download

- (void)downloadLatestIncidents {
    self.loading = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:[TORIncident parseClassName]];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:TORDefaultsLastSyncDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (!error) {
            self.incidents = [objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO]]];
            [self cacheIncidents:self.incidents];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        self.loading = NO;
    }];
}

#pragma mark - Incidents cache

- (NSArray *)cachedIncidents {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:TORDefaultsIncidentsCache]];
}

- (void)cacheIncidents:(NSArray *)incidents {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:incidents] forKey:TORDefaultsIncidentsCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
