//
//  WPYTabBarController.h
//  ZZ15191060WangPengYu
//
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewVC.h"
#import "CustomButtonVC.h"
#import "CustomFunctionVC.h"
#import "CustomModuleVC.h"
@interface WPYTabBarController : UITabBarController

@property (nonatomic, strong)CustomViewVC * customViewVC;
@property (nonatomic, strong)CustomButtonVC * customButtonVC;
@property (nonatomic, strong)CustomFunctionVC  * customFunctionVC;
@property (nonatomic, strong)CustomModuleVC * customModuleVC;
@end
