//
//  UIColor+ColorCategory.m
//  MyWarehouse
//
//  Created by Administrator on 29.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "UIColor+ColorCategory.h"

@implementation UIColor (ColorCategory)

+ (UIColor *) receiveRandomColor {
    
    CGFloat red = (float)(arc4random() % 256) / 255;
    CGFloat green = (float)(arc4random() % 256) / 255;
    CGFloat blue = (float)(arc4random() % 256) / 255;
                          
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    
}

@end
