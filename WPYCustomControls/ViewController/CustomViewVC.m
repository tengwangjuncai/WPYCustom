//
//  CustomViewVC.m
//  WPYCustomControls
//
//  Created by 又一车－UI on 2017/2/19.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomViewVC.h"
#import "UIImageView+WebCache.h"
#import "WPYNavBar.h"
#import "CustomButtonVC.h"
#import "CustomModuleVC.h"
#import "CustomFunctionVC.h"
#import "PageViewControllerCell.h"
#import "BaseTableViewController.h"
#import "PersonalCenterTableView.h"
#import "YUSegment.h"
@interface CustomViewVC ()<UITableViewDelegate,UITableViewDataSource,WPYNavBarDelegat,PageViewControllerCellDelegate>
@property (nonatomic,strong)PersonalCenterTableView * tabView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) WPYNavBar * navBar;

@property (nonatomic, strong) BaseTableViewController * btnVC;

@property (nonatomic, strong) BaseTableViewController * funtionVC;

@property (nonatomic, strong) BaseTableViewController * moduleVC;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) PageViewControllerCell * cell;

@property (nonatomic, strong) YUSegment * segment;
@property (nonatomic)BOOL canScroll;
@end

@implementation CustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self addNotification];
}


- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.7)];
        
        _headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        _headerImageView.image = [UIImage imageNamed:@"小黄人5"];
        
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_headerView addSubview:_headerImageView];
    }
    
    return _headerView;
}



- (WPYNavBar *)navBar {
    
    if (!_navBar) {
        _navBar = [[WPYNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titleColor:[UIColor blackColor] andSelectTitleColor:kThemeColor];
        
        [_navBar AddNavBarArray:@[@"导游讲解",@"景点详情",@"游玩攻略"] isBtnLine:YES btnLineColor:kThemeColor];
        _navBar.delegate = self;
    }
    
    return _navBar;
}

-(YUSegment *)segment
{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[@"Profile",@"Weibo",@"Album"]];
        _segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _segment.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        _segment.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        _segment.selectedTextColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
        _segment.indicator.backgroundColor = [UIColor colorWithRed:0.08 green:0.77 blue:1.00 alpha:1.00];
        [_segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

-(void) setupUI {
    _tabView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tabView];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.tabView registerClass:[PageViewControllerCell class] forCellReuseIdentifier:@"PageViewControllerCell"];
  //  self.navigationController.navigationBar.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha =  0.f;
//    
//    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        UIEdgeInsets insets = self.tabView.contentInset;
//        insets.top = self.navigationController.navigationBar.bounds.size.height;
//        self.tabView.contentInset = insets;
//        self.tabView.scrollIndicatorInsets = insets;
//    }
    
    self.canScroll = YES;

    self.tabView.tableHeaderView = self.headerView;
}


- (NSArray *)setupViewControllers{
    
    self.btnVC = [[BaseTableViewController alloc] init];
    self.btnVC.view.backgroundColor = [UIColor redColor];
    self.btnVC.delegate = self;
    
    
    self.funtionVC = [[BaseTableViewController alloc] init];
    self.funtionVC.view.backgroundColor = [UIColor greenColor];
    self.funtionVC.delegate = self;
    
    
    self.moduleVC = [[BaseTableViewController alloc] init];
    self.moduleVC.delegate = self;
    self.moduleVC.view.backgroundColor = [UIColor blueColor];
    self.dataSource = [NSMutableArray arrayWithArray:@[self.btnVC,self.funtionVC,self.moduleVC]];
    
    return self.dataSource;
}



#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset = self.tabView.contentOffset.y;
    CGFloat H = SCREEN_WIDTH/16 * 9.0;
    if (yOffset <= 0) {
        
        CGFloat factor = -yOffset + H ;
        CGRect f = CGRectMake(- (SCREEN_WIDTH * factor/H - SCREEN_WIDTH)/2, yOffset, SCREEN_WIDTH *factor/H, factor);
        self.headerImageView.frame = f;
    }
    
    if (yOffset <= H - 20  ) {
        
        CGFloat aplha = yOffset /(H -20);
        
        [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha=aplha;
    }else {
        [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha=1;
    }
    
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tabView rectForSection:0].origin.y-64;
    
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            
            _canScroll = NO;
            self.cell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_cell) {
        _cell = [tableView dequeueReusableCellWithIdentifier:@"PageViewControllerCell"];
         _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.delegate = self;
        [_cell setupWithArray];
    }
    
    return self.cell;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView * sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    
    if (!sectionHeadView) {
        sectionHeadView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headView"];
        [sectionHeadView addSubview:self.navBar];
    }
    
    return sectionHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_HEIGHT - 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}


- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
}
#pragma mark -- PageViewControllerCellDelegate

- (void)pageVCChangeToNum:(NSInteger)num
{
    [self.navBar selectTheButton:num];
}


//子控制器到顶部了 主控制器可以滑动
- (void)scrollToTop
{
    self.canScroll = YES;
    self.cell.canScroll = NO;
}

//当滑动下面的PageView时，当前的tableView要禁止滑动
- (void)scrollToBottomWithPosition:(NSString *)position
{
    if ([position isEqualToString:@"ended"]) {
        // pageView不动  tableView 动
        self.tabView.scrollEnabled = YES;
    }else {
        
        // pageView动  tableView 不动
        self.tabView.scrollEnabled = NO;
    }
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tabView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        self.tabView.scrollEnabled = NO;
    }
}


- (void)onSegmentChange {
    //改变pageView的页码
    self.cell.selectedIndex = self.segment.selectedIndex;
}

#pragma mark -- WPYNavBarDelegat

- (void)selectChangetoViewNum:(NSInteger)num {
    
    self.cell.selectedIndex = num;
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
