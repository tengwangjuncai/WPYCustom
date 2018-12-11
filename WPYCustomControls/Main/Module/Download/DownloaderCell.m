//
//  DownloaderCell.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/11.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "DownloaderCell.h"
#import "MCDownloader.h"
@implementation DownloaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configDataWith:(NSDictionary *)dict {
    
    self.showImageView.image = [UIImage imageNamed:dict[@"imageName"]];
    
    self.nameLabel.text = dict[@"imageName"];
    
    self.url = dict[@"urlStr"];
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    
    receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
        
        NSString * cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString * cacheFolderPath = [cacheDir stringByAppendingPathComponent:@"小黄人"];
        
        return [cacheFolderPath stringByAppendingPathComponent:_url.lastPathComponent];
    };
    
    self.nameLabel.text = receipt.truename;
    
    if (receipt.state == MCDownloadStateCompleted) {
        self.speedLabel.textColor = [UIColor orangeColor];
        self.speedLabel.text = @"下载完成";
        self.progressView.hidden = YES;
    }else if(receipt.state == MCDownloadStateFailed){
        self.speedLabel.textColor = kThemeRedColor;
        self.speedLabel.text = @"下载失败";
        self.progressView.hidden = NO;
    }else{
         self.speedLabel.text = nil;
        self.progressView.hidden = NO;
    }
    self.totalLabel.text = nil;
    self.progressView.progress = 0;
    self.progressView.progress = receipt.progress.fractionCompleted;
    
    __weak typeof (receipt) weakReceipt = receipt;
    
    receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
        __strong typeof(weakReceipt) strongReceipt = weakReceipt;
        
        if ([targetURL.absoluteString isEqualToString:_url]) {
            
            self.totalLabel.text = [NSString stringWithFormat:@"%0.1fM",expectedSize/1024.0/1024];
            self.progressView.progress = (receivedSize/1024.0/1024)/(expectedSize/1024.0/1024);
            
            self.speedLabel.textColor = kContentColor;
            self.speedLabel.text = [NSString stringWithFormat:@"%@/s", strongReceipt.speed ?:@"0"];
        }
    };
    
    receipt.downloaderCompletedBlock = ^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished)  {
      
        if (error) {
            self.speedLabel.textColor = kThemeRedColor;
            self.speedLabel.text = @"下载失败";
        }else {
            self.speedLabel.textColor = [UIColor orangeColor];
            self.speedLabel.text = @"下载完成";
            self.progressView.hidden = YES;
        }
    };
    
}


- (void)tapAction {
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    
    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
        
        [[MCDownloader sharedDownloader] cancel:receipt completed:^{
            self.speedLabel.textColor = [UIColor orangeColor];
            self.speedLabel.text = @"已暂停";
        }];
        
    }else if(receipt.state == MCDownloadStateCompleted){
        
        if (_delegate && [_delegate respondsToSelector: @selector(playVideoWithURL:)]) {
            
            [_delegate playVideoWithURL:self.url];
        }
        
    }else {
        
        [self download];
    }
}


- (void)download {
    
    [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:self.url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        
    }];
}


@end
