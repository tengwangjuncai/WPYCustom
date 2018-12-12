//
//  DownloadViewController.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/11.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloaderCell.h"
#import "MCDownloader.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WPYPlayVC.h"

//导航条高度
#define kNavigationBarHeight    (ISiPhoneX ? 88:64)
// 获取屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate,DownloaderCellDelegate>

@property (nonatomic, strong)UIButton * editBtn;

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)UIButton * allDownloadOrPauseBtn;

@property (nonatomic, strong)UIButton * limiteBtn;

@property (nonatomic, strong)UIView * headerView;

@property (nonatomic, strong)UIView * deleteView;// 按下编辑按钮 出现的删除面板

@property (nonatomic, strong)UIButton * allBtn;//全选按钮

@property (nonatomic, strong)UIButton * deleteBtn;//删除按钮

@property (nonatomic, strong)NSMutableArray * dataSource;

@property (nonatomic, strong)NSMutableArray * deleteArray;//需要删除的数据源
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
    [self loadData];
}

- (UIView *)deleteView {
    
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 49, SCREEN_WIDTH, 49)];
        _deleteView.backgroundColor = [UIColor whiteColor];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_deleteView addSubview:lineView];
        
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 48);
        [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_allBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:_allBtn];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(SCREEN_WIDTH/2,0, SCREEN_WIDTH/2, 48);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletedVideo) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:_deleteBtn];
        
        UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 4, 1, 40)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [_deleteView addSubview:lineView2];
        _deleteView.hidden = YES;
    }
    
    return _deleteView;
}


- (void)allSelected:(UIButton *)sender {
    
    if (!sender.selected) {
        for (int i = 0; i < self.dataSource.count; i++) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            if (![self.deleteArray containsObject:self.dataSource[i]]) {
                
                [self.deleteArray addObject:self.dataSource[i]];
            }
        }
        
        [self changeBtnState];
    }else {
        
        for (int i = 0; i< self.dataSource.count; i++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        [self.deleteArray removeAllObjects];
        
       [self changeBtnState];
    }
    
}

- (void)changeBtnState {
    
  
        if (self.deleteArray.count > 0) {
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.deleteArray.count] forState:UIControlStateNormal];
            self.deleteBtn.selected = YES;
            if (self.deleteArray.count == self.dataSource.count) {
                self.allBtn.selected = YES;
            }else{
                self.allBtn.selected = NO;
            }
        }else {
            self.allBtn.selected = NO;
            self.deleteBtn.selected = NO;
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        }
}
- (void)deletedVideo{
    
    if (self.deleteBtn.selected) {
        
        self.editBtn.selected = NO;
        self.tableView.editing = NO;
        self.deleteView.hidden = YES;
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight );
        [self deleteDonlowdVideo];
        [self changeBtnState];
    }
    
}

- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _allDownloadOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allDownloadOrPauseBtn.frame = CGRectMake(10, 10, (SCREEN_WIDTH - 30)/2, 30);
        [_allDownloadOrPauseBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _allDownloadOrPauseBtn.titleLabel.font = Font(14);
        
        _allDownloadOrPauseBtn.backgroundColor = kBGColor;
        [_allDownloadOrPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];
        [_allDownloadOrPauseBtn setTitle:@"全部暂停" forState:UIControlStateSelected];
        [_allDownloadOrPauseBtn addTarget:self action:@selector(allDownloadOrPauseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _allDownloadOrPauseBtn.layer.cornerRadius = 5;
        _allDownloadOrPauseBtn.clipsToBounds = YES;
        
        [_headerView addSubview:_allDownloadOrPauseBtn];
        
        _limiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _limiteBtn.frame = CGRectMake(20 + (SCREEN_WIDTH - 30)/2, 10, (SCREEN_WIDTH - 30)/2, 30);
        [_limiteBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_limiteBtn setTitle:@"同时缓存个数3" forState:UIControlStateNormal];
        [_limiteBtn addTarget:self action:@selector(limiteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _limiteBtn.titleLabel.font = Font(14);
        _limiteBtn.backgroundColor = kBGColor;
        _limiteBtn.layer.cornerRadius = 5;
        _limiteBtn.clipsToBounds = YES;
        [_headerView addSubview:_limiteBtn];
    }
    
    return _headerView;
}

- (void)allDownloadOrPauseBtnClicked:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = YES;
        
        for (NSDictionary * dict in self.dataSource) {
            
            [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:dict[@"urlStr"]] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                
            }];
        }
    }else {
        
        [[MCDownloader sharedDownloader] cancelAllDownloads];
        sender.selected = NO;
    }
    
    [self.tableView reloadData];
    
}

- (void)limiteBtnClicked:(UIButton *)sender {
    
}
-(void)setup{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.tableHeaderView = self.headerView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DownloaderCell" bundle:nil] forCellReuseIdentifier:@"DownloaderCell"];
    
    
    [self.view addSubview:self.deleteView];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 44, 44);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"取消" forState:UIControlStateSelected];
    _editBtn.titleLabel.font = Font(14);
    [_editBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.translucent = NO;
    self.title = @"我的下载";
}

- (NSMutableArray *)deleteArray {
    
    if (!_deleteArray) {
        _deleteArray = [[NSMutableArray alloc] init];
    }
    
    return _deleteArray;
}
- (void)editBtnClicked:(UIButton *)sender {
    
    if (self.dataSource.count == 0) {
        return;
    }
    
    if (!sender.selected) {
        
        self.tableView.editing = YES;
        self.deleteView.hidden = NO;
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight - 49);
        sender.selected = YES;
    }else {
        
        self.tableView.editing = NO;
        self.deleteView.hidden = YES;
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight );
        sender.selected = NO;
        [self.deleteArray removeAllObjects];
        [self changeBtnState];
    }
}
- (void)loadData {
    
    self.dataSource = [NSMutableArray new];
    NSArray * imageNames = @[@"小黄人1",@"小黄人2",@"小黄人3",@"小黄人4",@"小黄人5"];
    
    
    for (int i=0; i < 5; i++) {
        
        NSMutableDictionary * dict = [NSMutableDictionary new];
        
        NSString * urlStr = [NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i];
        
        [dict setObject:urlStr forKey:@"urlStr"];
        [dict setObject:imageNames[i] forKey:@"imageName"];
        
        [self.dataSource addObject:dict];
    }

}


- (void)deleteDonlowdVideo {
    
   
    for (NSDictionary * dict in self.deleteArray) {
        
        MCDownloadReceipt * receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:dict[@"urlStr"]];
        
        [[MCDownloader sharedDownloader]  remove:receipt completed:nil];
        
    }
    
    [self.dataSource removeObjectsInArray:self.deleteArray];
    [self.tableView reloadData];
    [self.deleteArray removeAllObjects];
   
}
#pragma mark -- DownloaderCellDelegate

- (void)playVideoWithURL:(NSString *)url {
    
     WPYPlayVC * playVC = [[WPYPlayVC alloc] init];
     MCDownloadReceipt * receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
    WMPlayer * videoView = [[UIApplication sharedApplication].keyWindow viewWithTag:1080];
    if (videoView && [receipt.filePath isEqualToString:videoView.URLString]) {
        self.navigationController.delegate = playVC;
        
    }else{
    
    if (videoView) {
        [videoView pause];
//        videoView.isflow = NO;
        [videoView removeFromSuperview];
    }
    playVC.url = receipt.filePath;
        
    }
    
    [self.navigationController pushViewController:playVC animated:YES];
    
}


#pragma mark --   UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DownloaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloaderCell"];
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    cell.delegate = self;
    [cell configDataWith:dict];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    if (tableView.editing) {
        
        if (![self.deleteArray containsObject:dict]) {
            [self.deleteArray addObject:dict];
            
            [self changeBtnState];
            return;
        }
    }
    
    DownloaderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell tapAction];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    if (tableView.editing) {
        [self.deleteArray removeObject:dict];
        [self changeBtnState];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.editing = NO;
    
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    [self.deleteArray addObject:dict];
    [self deleteDonlowdVideo];
    
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
