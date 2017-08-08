//
//  WPYTabBar.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/26.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "WPYTabBar.h"
#import "WPYItemBtn.h"
@interface WPYTabBar()

@property (nonatomic, strong)NSMutableArray * tabBarBtnArray;
@property (nonatomic, weak) WPYItemBtn * selectedButton;
@property (nonatomic, strong)UIButton * CreateBtn;
@end
@implementation WPYTabBar

- (NSMutableArray *)tabBarBtnArray {
    
    if (!_tabBarBtnArray) {
        _tabBarBtnArray = [NSMutableArray array];
    }
    
    return _tabBarBtnArray;
    
}


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupCreateButton];
    }
    
    return self;
}

- (void)setupCreateButton {
    
    UIButton * createBtn = [UIButton new];
    
    createBtn.adjustsImageWhenHighlighted = NO;
    [createBtn setBackgroundImage:[UIImage imageNamed:@"添加-2"] forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(ClickCreateBtn) forControlEvents:UIControlEventTouchUpInside];
    createBtn.bounds = CGRectMake(0, 0, createBtn.currentBackgroundImage.size.width, createBtn.currentBackgroundImage.size.height);
    
    [self addSubview:createBtn];
    _CreateBtn = createBtn;
}



- (void)layoutSubviews {
    
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width / (self.subviews.count);
    CGFloat btnH = self.frame.size.height;
    self.CreateBtn.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5 -  15);
    for (int  index = 0; index < self.tabBarBtnArray.count; index++) {
        CGFloat btnX = btnW * index;
        WPYItemBtn * tabBarBtn = self.tabBarBtnArray[index];
        
        if (index > 1) {
            btnX += btnW;
        }
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = index;
    }
}

- (void)ClickCreateBtn {
    
    if ([self.delegate respondsToSelector:@selector(tabBarClickWriteButton:)]) {
        [self.delegate tabBarClickWriteButton:self];
    }
}

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem {
    
    WPYItemBtn * tabBarBtn = [[WPYItemBtn alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabBarBtnArray addObject:tabBarBtn];
    
    if (self.tabBarBtnArray.count == 1) {
        [self ClickTabBarButton:tabBarBtn];
    }
}


- (void)ClickTabBarButton:(WPYItemBtn *)tabBarBtn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    WPYItemBtn * tabBarBtn = self.tabBarBtnArray[selectIndex];
    self.selectedButton.selected = NO;
    
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
