//
//  CustomViewVC.m
//  WPYCustomControls
//
//  Created by 又一车－UI on 2017/2/19.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomViewVC.h"
#import "UIImageView+WebCache.h"
@interface CustomViewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tabView;
@end

@implementation CustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void) setupUI {
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 108) style:UITableViewStylePlain];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    [self.view addSubview:_tabView];
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UIEdgeInsets insets = self.tabView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height;
        self.tabView.contentInset = insets;
        self.tabView.scrollIndicatorInsets = insets;
    }
    
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0) {
        self.navigationController.navigationBar.hidden = YES;
        self.tabView.frame =CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 69);
    }else {
        self.navigationController.navigationBar.hidden = NO;
        self.tabView.frame =CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 113);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
   [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://static.imguider.com/upload/images/20170713/1499934062736.jpg"] placeholderImage:[UIImage imageNamed:@""]];
    
    //cell.imageView.image = [UIImage imageNamed:@"image"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
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
