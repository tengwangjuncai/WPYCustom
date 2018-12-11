//
//  WPYTabBarController.m
//  ZZ15191060WangPengYu
//
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "WPYTabBarController.h"
#import "WPYNavigationController.h"
#import "WPYTabBar.h"
#define ColorValue arc4random()%256/255.0
@interface WPYTabBarController ()<WPYTabBarDelegate>

@property (nonatomic, weak)WPYTabBar * mainTabBar;

@end

@implementation WPYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = [self createViewControllers];
    [self setMainTabBar];
    [self createViewControllers];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    self.mainTabBar.selectIndex = selectedIndex;
}
- (void)setMainTabBar {
    WPYTabBar *mainTabBar = [[WPYTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}
- (NSArray *)createViewControllers {
    
    NSArray *titles = @[@"页面",@"按钮",@"功能",@"模块"];
    NSArray *imageNames = @[@"页面",@"播放按钮",@"圈子",@"操作_模块切换"];
    NSArray * selectImageNames = @[@"页面-2",@"播放按钮-2",@"圈子-2",@"操作_模块切换-2"];
    
    self.customViewVC = [[CustomViewVC alloc] init];
    self.customButtonVC = [[CustomButtonVC alloc] init];
    self.customFunctionVC = [[CustomFunctionVC alloc] init];
    self.customModuleVC = [[CustomModuleVC alloc] init];
    
    NSArray * viewControllers = @[self.customViewVC, self.customButtonVC,self.customFunctionVC,self.customModuleVC];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (int i = 0; i < viewControllers.count; i++) {
        
        UIViewController * childVC = viewControllers[i];
        [self setupChildVC:childVC title:titles[i] image:imageNames[i] selectedImage:selectImageNames[i]];
    }
    
    return resultArray;
}


- (void)setupChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    
    WPYNavigationController * nav = [[WPYNavigationController alloc] initWithRootViewController:childVC];
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVC.tabBarItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVC.tabBarItem];
    [self addChildViewController:nav];
}

- (void)tabBar:(WPYTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag {
    self.selectedIndex = toBtnTag;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
