//
//  DownloaderCell.h
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/11.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


- (void)configDataWith:(NSDictionary *)dict;
@end
