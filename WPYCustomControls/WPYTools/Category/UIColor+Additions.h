//
//  UIColor+Additions.h
//  YuanGongBao
//
//  Created by wangyaqing on 14-9-15.
//  Copyright (c) 2014年 YiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorWithHex:(NSUInteger)hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
