//
//  TORIncidentsViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentsViewModel.h"

#import "TORIncident.h"
#import "TORAppDelegate.h"

@interface TORIncidentsViewModel ()
@property (strong, nonatomic) NSArray *incidents;
@property (assign, nonatomic, getter = isLoading) BOOL loading;
@property (readonly, copy, nonatomic) PFQuery *query;
@end

@implementation TORIncidentsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        PFQuery *query = [self.query fromLocalDatastore];
        @weakify(self);
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            @strongify(self);
            if (!error) {
                self.incidents = objects;
            }
        }];

        self.loading = NO;
        _pushEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:TORDefaultsPushMessage];
        [RACObserve(self, pushEnabled) subscribeNext:^(NSNumber *flag) {
            BOOL isPushEnabled = flag.boolValue;
            UIApplication *application = [UIApplication sharedApplication];
            if (isPushEnabled) {
                [(TORAppDelegate *)application.delegate enableNotificationsForApplication:application];
            }
            else {
                [application unregisterForRemoteNotifications];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation removeObject:@"active" forKey:@"channels"];
                [currentInstallation saveInBackground];
            }

            [[NSUserDefaults standardUserDefaults] setBool:isPushEnabled forKey:TORDefaultsPushMessage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];

        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self downloadLatestIncidents];
        }];
    }
    return self;
}

#pragma mark - Query

- (PFQuery *)query
{
    PFQuery *query = [PFQuery queryWithClassName:[TORIncident parseClassName]];
    query.limit = 20;
    [query orderByDescending:@"publishedAt"];
    return query;
}

- (void)downloadLatestIncidents {
    self.loading = YES;
    PFQuery *query = self.query;
    @weakify(self);
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:TORDefaultsLastSyncDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (!error) {
            [TORIncident pinAllInBackground:objects];
            self.incidents = objects;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        self.loading = NO;
    }];
}

#pragma mark - Push

- (NSString *)pushTitle {
    return self.isPushEnabled ? LS(@"incidents.push.actionsheet.disable.title") : LS(@"incidents.push.actionsheet.enable.title");
}

- (NSString *)pushAction {
    return self.isPushEnabled ? LS(@"incidents.push.actionsheet.disable") : LS(@"incidents.push.actionsheet.enable");
}

@end
