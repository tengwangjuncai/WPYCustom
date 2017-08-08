//
//  WPYTabBar.h
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/26.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPYTabBarDelegate;

@interface WPYTabBar : UIView

@property (nonatomic, weak)id<WPYTabBarDelegate>delegate;

@property (nonatomic)NSInteger selectIndex;

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;



@end

@protocol WPYTabBarDelegate <NSObject>

@optional
- (void)tabBar:(WPYTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;

- (void)tabBarClickWriteButton:(WPYTabBar *)tabBar;
@end
