//
//  CustomModuleVC.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/27.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomModuleVC.h"
#import "MapVC.h"
#import "IGShare.h"
#import "DownloadViewController.h"
@interface CustomModuleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tabView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@end

@implementation CustomModuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

-(void) setupUI {
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    [self.view addSubview:_tabView];
    
    _dataSource = [NSMutableArray arrayWithArray:@[@"地图",@"下载",@"友盟分享"]];//,@"支付",@"登录",@"数据管理
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"                %@",self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            MapVC * vc = [[MapVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            DownloadViewController * vc = [[DownloadViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            
            [IGShare shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine withURL:@"http://www.imguider.com" Title:@"测试title" descr:@"测试desc" thumImage:[UIImage imageNamed:@"share"]   completion:^(id result, NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
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
