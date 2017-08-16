//
//  DownloadViewController.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/11.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloaderCell.h"
@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UIButton * editBtn;

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)UIButton * allDownloadOrPauseBtn;

@property (nonatomic, strong)UIButton * limiteBtn;

@property (nonatomic, strong)UIView * headerView;

@property (nonatomic, strong)NSMutableArray * dataSource;
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _allDownloadOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allDownloadOrPauseBtn.frame = CGRectMake(10, 10, (SCREEN_WIDTH - 30)/2, 30);
        [_allDownloadOrPauseBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _allDownloadOrPauseBtn.titleLabel.font = Font(14);
        
        _allDownloadOrPauseBtn.backgroundColor = kContentColor;
        [_allDownloadOrPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];
        [_allDownloadOrPauseBtn setTitle:@"全部暂停" forState:UIControlStateSelected];
        _allDownloadOrPauseBtn.layer.cornerRadius = 5;
        _allDownloadOrPauseBtn.clipsToBounds = YES;
        
        [_headerView addSubview:_allDownloadOrPauseBtn];
        
        _limiteBtn.frame = CGRectMake(20 + (SCREEN_WIDTH - 30)/2, 10, (SCREEN_WIDTH - 30)/2, 30);
        [_limiteBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_limiteBtn setTitle:@"同时缓存个数3" forState:UIControlStateNormal];
        _limiteBtn.titleLabel.font = Font(14);
        _limiteBtn.backgroundColor = kContentColor;
        _limiteBtn.layer.cornerRadius = 5;
        _limiteBtn.clipsToBounds = YES;
        [_headerView addSubview:_limiteBtn];
    }
    
    return _headerView;
}


-(void)setup{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_headerView];
    
    _tableView.tableHeaderView = self.headerView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DownloaderCell" bundle:nil] forCellReuseIdentifier:@"DownloaderCell"];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 44, 44);
    [_editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)editBtnClicked:(UIButton *)sender {
    
}
- (void)loadData {
    
}




#pragma mark --   UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DownloaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloaderCell"];
    
    
    
    return cell;
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
