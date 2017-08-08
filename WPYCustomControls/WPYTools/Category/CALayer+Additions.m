//
//  CALayer+Additions.m
//  YourNextCar
//
//  Created by LLT on 16/3/15.
//  Copyright © 2016年 LLT. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)


- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
@end
