//
//  TORIncidentCell.m
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentCell.h"

#import "TORIncident.h"

@interface TORIncidentCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TORIncidentCell

#pragma mark - Nib

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = TORBlackTextColor;
    self.dateLabel.textColor = TORGreyTextColor;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds) - 2.0 * 15.0;
}

#pragma mark - Configuration

- (void)configureWithIncident:(TORIncident *)incident
{
    self.titleLabel.text = incident.title;
    self.dateLabel.text = [self dateStringFromDate:incident.publishedAt];
}

- (NSString *)dateStringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"da_DK"];
    });
    return [dateFormatter stringFromDate:date];
}

@end
