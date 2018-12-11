//
//  CustomFunctionVC.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/27.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomFunctionVC.h"
#import "NumberSearchVC.h"
#import "ScenicPoint.h"
@interface CustomFunctionVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CustomFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigation];
    [self createTableView];
    [self setLargeTitle];
    
}
- (void)setLargeTitle {
    
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }
    
}
- (void)setNavigation {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    
    [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(popSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)createTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight - 49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = NO;
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        // Fallback on earlier versions
    }
}







#pragma mark - SnailSheetViewDelegate



- (NSMutableArray<ScenicPoint*> *)createDataSource {
    
    NSMutableArray * arr = [NSMutableArray new];
    
    for (int i = 0; i < 20; i++) {
        ScenicPoint * point = [[ScenicPoint alloc] init];
        point.spotname = [NSString stringWithFormat:@"第%d个测试数据",i];
        point.number = @(i).stringValue;
        
        [arr addObject:point];
    }
    
    return arr;
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld 大头title测",indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 30;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NumberSearchVC * searchVC = [[NumberSearchVC alloc] init];
    
    searchVC.ScenicPointsArray = [self createDataSource];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
