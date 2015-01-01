//
//  TORIncidentViewModel.m
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "TORIncidentViewModel.h"
#import "TORIncident.h"

#import "UIColor+Hex.h"

@interface TORIncidentViewModel ()
@property (strong, nonatomic) TORIncident *incident;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSAttributedString *content;
@end

@implementation TORIncidentViewModel

- (instancetype)initWithIncident:(TORIncident *)incident {
    self = [super init];
    if (self) {
        self.incident = incident;
        
        RAC(self, title) = RACObserve(self.incident, title);
        RAC(self, content) = [RACObserve(self.incident, content) map:^(NSString *content) {
            UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            NSString *stringHtml = [NSString stringWithFormat:@"<div style=\"font-family: %@; font-size: %f; color: #%@; text-align: left;\">%@</div>", font.fontName, font.pointSize, TORBlackTextColor.hexString, content];
            return [[NSAttributedString alloc] initWithData:[stringHtml dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                              NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                         documentAttributes:nil error:nil];
        }];
    }
    return self;
}

@end
