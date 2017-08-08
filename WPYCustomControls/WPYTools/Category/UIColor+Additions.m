//
//  UIColor+Additions.m
//  YuanGongBao
//
//  Created by wangyaqing on 14-9-15.
//  Copyright (c) 2014年 YiJie. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorWithHex:(NSUInteger)hex
{
    NSUInteger a = (hex >> 24) & 0xFF;
    NSUInteger r = (hex >> 16) & 0xFF;
    NSUInteger g = (hex >> 8 ) & 0xFF;
    NSUInteger b = hex & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned long long colorValue = 0;
    [scanner scanHexLongLong:&colorValue];
    unsigned long long redValue = (colorValue & 0xFF0000) >> 16;
    unsigned long long greenValue = (colorValue & 0xFF00) >> 8;
    unsigned long long blueValue = colorValue & 0xFF;
    return [UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:1];
}

+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
