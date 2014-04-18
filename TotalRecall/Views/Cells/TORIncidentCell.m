//
//  TORIncidentCell.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentCell.h"

#import "TORIncident.h"

@implementation TORIncidentCell

- (void)awakeFromNib {
    self.textLabel.textColor = [UIColor colorWithHexString:@"2B2B2B"];
    self.detailTextLabel.textColor = [UIColor colorWithHexString:@"8E8E93"];
}

#pragma mark - Configuration

- (void)configureWithIncident:(TORIncident *)incident {
    self.textLabel.text = incident.title;
    self.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:incident.publishedAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

@end
