//
//  CustomFunctionVC.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/27.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomFunctionVC.h"
#import "SnailPopupController.h"
#import "SnailSheetView.h"
@interface CustomFunctionVC ()<SnailSheetViewConfigDelegate,SnailSheetViewDelegate>

@end

@implementation CustomFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    
    [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(popSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
}

- (SnailSheetView *)sheetViewWithDelegate:(id<SnailSheetViewConfigDelegate>)delegate {
    
    SnailSheetView * sheet = [[SnailSheetView alloc] initWithFrame:CGRectMake(100, 100, SCREEN_WIDTH, 300) configDelegate:delegate];
    sheet.headerLabel.text = @"IMGuider.com";
    
    sheet.models = [self sheetModels];
    [sheet autoresizingFlexibleHeight];
    
    return sheet;
}

- (void)popSheet:(UIButton *)sender {
    
    SnailSheetView * sheet = [self sheetViewWithDelegate:self];
    sheet.delegate = self;
    sheet.didClickFooter = ^(SnailSheetView * _Nonnull sheetView) {
        [self.sl_popupController dismiss];
    };
    
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.layoutType = PopupLayoutTypeBottom;
    [self.sl_popupController presentContentView:sheet];
    
}


#pragma mark - SnailSheetViewConfig

- (SnailSheetViewLayout *)layoutOfItemInSheetView:(SnailSheetView *)sheetView {
    
    return [SnailSheetViewLayout layoutWithItemSize:CGSizeMake(70, 100)
                                      itemEdgeInset:UIEdgeInsetsMake(15, 10, 5, 10)
                                        itemSpacing:2
                                     imageViewWidth:60
                                         subSpacing:5];
}

#pragma mark - SnailSheetViewDelegate

- (void)sheetView:(SnailSheetView *)sheetView didSelectItemAtSection:(NSInteger)section index:(NSInteger)index {
    SnailSheetItemModel *model = [self sheetModels][section][index];
    @weakify(self);
    self.sl_popupController.didDismiss = ^(SnailPopupController * _Nonnull popupController) {
        @strongify(self);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:model.text preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
        [self presentViewController:alert animated:YES completion:NULL];
    };
    [self.sl_popupController dismiss];
}


#define titleKey @"title"
#define imgNameKey @"imageName"


- (NSArray *)sheetModels {
    
    NSArray *arr1 = @[@{titleKey   : @"发送给朋友",
                        imgNameKey : @"sheet_Share"},
                      
                      @{titleKey   : @"分享到朋友圈",
                        imgNameKey : @"sheet_Moments"},
                      
                      @{titleKey   : @"收藏",
                        imgNameKey : @"sheet_Collection"},
                      
                      @{titleKey   : @"分享到\n手机QQ",
                        imgNameKey : @"sheet_qq"},
                      
                      @{titleKey   : @"分享到\nQQ空间",
                        imgNameKey : @"sheet_qzone"},
                      
                      @{titleKey   : @"在QQ浏览器\n中打开",
                        imgNameKey : @"sheet_qqbrowser"}];
    
    NSArray *arr2 = @[@{titleKey   : @"查看公众号",
                        imgNameKey : @"sheet_Verified"},
                      
                      @{titleKey   : @"复制链接",
                        imgNameKey : @"sheet_CopyLink"},
                      
                      @{titleKey   : @"复制文本",
                        imgNameKey : @"sheet_CopyText"},
                      
                      @{titleKey   : @"刷新",
                        imgNameKey : @"sheet_Refresh"},
                      
                      @{titleKey   : @"调整字体",
                        imgNameKey : @"sheet_Font"},
                      
                      @{titleKey   : @"投诉",
                        imgNameKey : @"sheet_Complaint"}];
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSDictionary *dict in arr1) {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array1 addObject:[SnailSheetItemModel modelWithText:text
                                                       image:[UIImage imageNamed:imgName]]];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (NSDictionary *dict in arr2) {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array2 addObject:[SnailSheetItemModel modelWithText:text
                                                       image:[UIImage imageNamed:imgName]]];
    }
    
    return [NSMutableArray arrayWithObjects:array1, array2, nil];
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
