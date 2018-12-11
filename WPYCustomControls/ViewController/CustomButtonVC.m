//
//  CustomButtonVC.m
//  WPYCustomControls
//
//  Created by 又一车－UI on 2017/2/19.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "CustomButtonVC.h"
#import "PlayBar.h"
#import "UIImageView+WebCache.h"
#import "progressView.h"
#import "SDWebImagePrefetcher.h"
#import "DAYCalendarView.h"
#import "TripDescView.h"

#import "SnailPopupController.h"
#import "SnailSheetView.h"
@interface CustomButtonVC ()<TripDescViewDelegate>

@end

@implementation CustomButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PlayBar * playBar = [PlayBar shareManeger];
    
    playBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    playBar.center = self.view.center;
   // [self.view addSubview:playBar];
    
   
    DAYCalendarView * calendarView = [[DAYCalendarView alloc] initWithFrame:CGRectMake(20, kNavigationBarHeight, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)/7*6)];
    
    //[self.view addSubview:calendarView];
    
    
   // [self createImage];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((SCREEN_WIDTH - 120)/2,SCREEN_HEIGHT - 150, 120, 44);
    [btn setTitle:@"展示全部" forState:UIControlStateNormal];
   [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}




-(void)pop {

    TripDescView * sheet = [[TripDescView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    sheet.delegate = self;
    
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.layoutType = PopupLayoutTypeTop;
    [self.sl_popupController presentContentView:sheet];

}


- (void)closeTripView {
    [self.sl_popupController dismiss];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  //  [self createImageView];
}


- (void)createImage {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, 200, 200)];
    
    imageView.backgroundColor = [UIColor redColor];
    
    NSURL * url1 = [NSURL URLWithString:@"http://static.imguider.com/upload/images/20170412/1491983032637_750.jpg"];
    
    NSURL * url2 = [NSURL URLWithString:@"http://static.imguider.com/upload/images/20170331/1490973141802_300.jpg"];
    
    
   // [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[url1,url2]];
    
   // [imageView sd_setImageWithURL:url2];
    
    [imageView sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@""]];
    
    [self.view addSubview:imageView];
}

- (void)createImageView {
    
    
    progressView * progress = [[progressView alloc] initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 200, 80, 80)];
    //[progress setImage:[UIImage imageNamed:@"lines_play"] forState:UIControlStateNormal];
    [progress setBackgroundImage:[UIImage imageNamed:@"lines_play"] forState:UIControlStateNormal];
    [self.view addSubview:progress];
    
    
    double delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        for (float i=0; i<1.1; i+=0.01F) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progress setProgress:i];
            });
            usleep(10000);
        }
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [progress setProgress:0];
        });
    });
}


//(
// http://static.imguider.com/upload/images/20170412/1491983032637_750.jpg,
// http://static.imguider.com/upload/images/20170331/1490973141802_300.jpg,
// http://static.imguider.com/upload/images/20170314/1489476794734_300.jpg,
// http://static.imguider.com/upload/images/20170426/1493191692373_300.png,
// http://static.imguider.com/upload/images/20170331/1490969899423_300.jpg,
// http://static.imguider.com/upload/images/20170314/1489477064177_300.jpg,
// http://static.imguider.com/upload/images/20170314/1489476697509_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490933618601_300.jpg,
// http://static.imguider.com/upload/images/20170421/1492763298591_300.png,
// http://static.imguider.com/upload/images/20170331/1490970158071_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490971180110_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490931924598_300.jpg,
// http://static.imguider.com/upload/images/20170426/1493188508637_300.png,
// http://static.imguider.com/upload/images/20170331/1490970562588_300.jpg,
// http://static.imguider.com/upload/images/20170315/1489579211168_300.jpg,
// http://static.imguider.com/upload/images/20170706/1499339671408_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490963850019_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490956381025_300.jpg,
// http://static.imguider.com/upload/images/20170516/1494908684316_300.jpg,
// http://static.imguider.com/upload/images/20170614/1497428519056_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490955387327_300.jpg,
// http://static.imguider.com/upload/images/20170706/1499342526465_300.jpg,
// http://static.imguider.com/upload/images/20170314/1489485139135_300.png,
// http://static.imguider.com/upload/images/20170421/1492772112706_300.png,
// http://static.imguider.com/upload/images/20170331/1490952968035_300.png,
// http://static.imguider.com/upload/images/20170331/1490937130772_300.png,
// http://static.imguider.com/upload/images/20170421/1492761457702_300.png,
// http://static.imguider.com/upload/images/20170423/1492924762689_300.png,
// http://static.imguider.com/upload/images/20170331/1490946752155_300.png,
// http://static.imguider.com/upload/images/20170331/1490964849862_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490952455851_300.png,
// http://static.imguider.com/upload/images/20170331/1490968287060_300.jpg,
// http://static.imguider.com/upload/images/20170314/1489483937160_300.png,
// http://static.imguider.com/upload/images/20170707/1499428211837_300.jpg,
// http://static.imguider.com/upload/images/20170421/1492773511443_300.png,
// http://static.imguider.com/upload/images/20170314/1489484512390_300.png,
// http://static.imguider.com/upload/images/20170314/1489483512527_300.png,
// http://static.imguider.com/upload/images/20170331/1490968105892_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490964017528_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490947147096_300.png,
// http://static.imguider.com/upload/images/20170423/1492929646380_300.png,
// http://static.imguider.com/upload/images/20170331/1490954663725_300.jpg,
// http://static.imguider.com/upload/images/20170426/1493202099144_300.png,
// http://static.imguider.com/upload/images/20170314/1489481407131_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490959638730_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490953373734_300.jpg,
// http://static.imguider.com/upload/images/20170707/1499428293848_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490932286841_300.jpg,
// http://static.imguider.com/upload/images/20170706/1499339469764_300.jpg,
// http://static.imguider.com/upload/images/20170424/1493026376913_300.png,
// http://static.imguider.com/upload/images/20170423/1492906078678_300.png,
// http://static.imguider.com/upload/images/20170331/1490970419566_300.jpg,
// http://static.imguider.com/upload/images/20170425/1493114289170_300.png,
// http://static.imguider.com/upload/images/20170423/1492932046076_300.png,
// http://static.imguider.com/upload/images/20170331/1490972211156_300.jpg,
// http://static.imguider.com/upload/images/20170707/1499428451148_300.jpg,
// http://static.imguider.com/upload/images/20170424/1493024699021_300.png,
// http://static.imguider.com/upload/images/20170331/1490972912084_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490958112657_300.png,
// http://static.imguider.com/upload/images/20170421/1492765015899_300.png,
// http://static.imguider.com/upload/images/20170314/1489477740356_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490963160791_300.png,
// http://static.imguider.com/upload/images/20170707/1499428798942_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490974017380_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490960401127_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490946252871_300.png,
// http://static.imguider.com/upload/images/20170331/1490937487248_300.jpg,
// http://static.imguider.com/upload/images/20170707/1499428972628_300.jpg,
// http://static.imguider.com/upload/images/20170331/1490972605451_300.jpg,
// http://static.imguider.com/upload/images/20170425/1493116081681_300.png,
// http://static.imguider.com/upload/images/20170331/1490971698167_300.jpg,
// http://static.imguider.com/upload/images/20170426/1493202312009_300.png,
// http://static.imguider.com/upload/images/20170331/1490973460198_300.jpg,
// http://static.imguider.com/upload/images/20170707/1499429052698_300.jpg,
// http://static.imguider.com/upload/images/20170706/1499342789247_300.jpg,
// http://static.imguider.com/upload/images/20170425/1493100771440_300.png,
// http://static.imguider.com/upload/images/20170331/1490964564737_300.jpg,
// http://static.imguider.com/upload/images/20170423/1492930364481_300.png,
// http://static.imguider.com/upload/images/20170421/1492710930407_300.png
// )

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
