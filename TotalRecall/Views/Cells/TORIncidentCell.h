//
//  TORIncidentCell.h
//  TotalRecall
//
//  Created by Morten Bøgh on 18/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

@import UIKit;

@class TORIncident;
@interface TORIncidentCell : UITableViewCell
- (void)configureWithIncident:(TORIncident *)incident;
@end
