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
#import "IGIMViewController.h"
#import "UIViewController+PopSheet.h"
#import "MyCamera.h"
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
    
    _dataSource = [NSMutableArray arrayWithArray:@[@"地图",@"下载",@"友盟分享",@"融云即时通信",@"照相机"]];//,@"支付",@"登录",@"数据管理
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
            // 这里的分享功能是单独出来的单例 什么地方都可以用
            // 但是有时候分享界面也会多处用到，怎么玩？
            // 解决：把分享界面弹出写到 UIViewController 的扩展类里（UIViewController+PopSheet.h） 这样就可以在想用的界面这届使用。只要在使用的界面 调 [self popSheet]
            //(注意：所以要改分享平台，图标 要在UIViewController+PopSheet.m 中做修改)
            // 虽然有可能多个界面都用到分享界面，但是分享的东西可能是不同的。所以没有把分享界面的点击回调写在扩展类里，这样在用分享界面的时候相应要实现   分享界面的回调方法 - (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index
            
            [self popSheet];
        }
            break;
        case 3:
        {
            IGIMViewController * chatVC = [[IGIMViewController alloc] init];
            
            [self.navigationController pushViewController:chatVC animated:YES];
            
            
        }
            break;
        case 4:
        {
            MyCamera * camera = [[MyCamera alloc] init];
            
            [self presentViewController:camera animated:YES completion:nil];
        }
        default:
            break;
    }
}




#pragma mark  --  SnailSheetViewDelegate

- (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index {
    
    SnailSheetItemModel *model = [self sheetModels][section][index];
    
   
    self.sl_popupController.didDismiss = ^(SnailPopupController * _Nonnull popupController) {
        
        [IGShare shareWebPageToPlatformType:model.platformType withURL:@"https://www.ixigua.com/a6495540133683528206/?utm_source=toutiao&utm_medium=feed_stream#mid=78175997570" title:@"UZI的VN Top10" descr:@"" thumImage:@"http://img1.imgtn.bdimg.com/it/u=1247560055,1904597120&fm=11&gp=0.jpg" object:nil type:1 completion:^(id result, NSError *error) {
            
        }];
    };
    [self.sl_popupController dismiss];
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
