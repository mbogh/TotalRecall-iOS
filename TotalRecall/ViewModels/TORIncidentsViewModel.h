//
//  TORIncidentsViewModel.h
//  TotalRecall
//
//  Created by Morten Bøgh on 20/04/14.
//  Copyright (c) 2014 Morten Bøgh. All rights reserved.
//

#import "RVMViewModel.h"

@interface TORIncidentsViewModel : RVMViewModel
@property (strong, readonly, nonatomic) NSArray *incidents;
@end
