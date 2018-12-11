//
//  DownloaderCell.h
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/11.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloaderCellDelegate<NSObject>

- (void)playVideoWithURL:(NSString *)url;

@end

@interface DownloaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, copy) NSString * url;

@property (nonatomic, weak) id<DownloaderCellDelegate> delegate;


- (void)configDataWith:(NSDictionary *)dict;

- (void)tapAction;
@end
