//
//  WPYItemBtn.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/26.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "WPYItemBtn.h"
#define TabBarButtonImageRatio 0.6
@interface WPYItemBtn()

@property (nonatomic, strong)UILabel * badge;
@end

@implementation WPYItemBtn
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView.contentMode = UIViewContentModeBottom;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = TABBAR_FONT;
        [self setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
        [self setTitleColor:LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        
        self.badge = [[UILabel alloc] init];
        self.badge.font = [UIFont systemFontOfSize:10];
        self.badge.textColor = [UIColor whiteColor];
        self.badge.textAlignment = NSTextAlignmentCenter;
        self.badge.hidden = true;
        self.badge.layer.backgroundColor = [UIColor redColor].CGColor;
        self.badge.layer.borderWidth = 1;
        self.badge.layer.borderColor = [UIColor whiteColor].CGColor;
        self.badge.layer.masksToBounds = true;
        [self addSubview:self.badge];
        
        
    }
    
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *TabBarButtonImageRatio;
    
    return CGRectMake(0, 0, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleY = contentRect.size.height * TabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW,titleH);
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)setBadgeText:(NSString *)BadgeText {
    
    NSInteger badgeNumber = BadgeText.integerValue;
    if (BadgeText.length == 0) {
        self.badge.hidden = TRUE;
    } else if (badgeNumber == 0) {
        self.badge.hidden = FALSE;
        self.badge.text = @"";
        self.badge.frame = CGRectMake(self.frame.size.width / 2 + 5, 4, 10, 10);
        self.badge.layer.cornerRadius = 5;
    } else {
        self.badge.hidden = FALSE;
        self.badge.text = [NSString stringWithFormat:@"%ld", (long)badgeNumber];
        CGSize size = [self.badge.text sizeWithAttributes:@{NSFontAttributeName :self.badge.font}];
        self.badge.frame = CGRectMake(self.frame.size.width / 2 + 5, 5, badgeNumber < 10 ? 16 : size.width + 12, 16);
        self.badge.layer.cornerRadius = 8;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSString * newBadge = change[NSKeyValueChangeNewKey];//取key为new对应的值
    if ([newBadge isKindOfClass:[NSNull class]]) {
        newBadge = nil;
    }
    
    [self setBadgeText:newBadge];
}

- (void)dealloc {
    [_tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
}
@end
