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
@property (weak, nonatomic) IBOutlet UILabel *summarylabel;

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
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds) - 15.0;
    self.summarylabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds) - 15.0;
    [self updateFonts];
}

#pragma mark - Configuration

- (void)configureWithIncident:(TORIncident *)incident
{
    self.titleLabel.text = incident.title;
    self.summarylabel.text = [incident.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

- (void)updateFonts
{
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.summarylabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

@end
