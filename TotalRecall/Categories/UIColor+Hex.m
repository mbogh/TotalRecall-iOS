//
//  UIColor+Hex.m
//  TotalRecall
//
//  Created by Morten Bøgh on 01/01/15.
//  Copyright (c) 2015 Morten Bøgh. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

- (NSString *)hexString
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue: &blue alpha: &alpha];

    NSInteger r = (NSInteger)(255.0 * red);
    NSInteger g = (NSInteger)(255.0 * green);
    NSInteger b = (NSInteger)(255.0 * blue);

    return [NSString stringWithFormat:@"%02lx%02lx%02lx", (long)r, (long)g, (long)b];
}

@end
