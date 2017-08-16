//
//  IGShare.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/14.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "IGShare.h"

@implementation IGShare



+ (void)configIGSharePlatforms {
    
    // 微信分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMENG_WX_APPID appSecret:UMENG_WX_APPSECRET redirectURL:nil];
    
    // QQ分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMENG_QQ_APPID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    // 新浪分享
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMENG_WB_APPKEY appSecret:UMENG_WB_APPSECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    //FB 分享
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:UMENG_FB_APPID  appSecret:nil redirectURL:nil];
}


+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withURL:(NSString *)url  Title:(NSString *)title descr:(NSString *)desc thumImage:(id)thumImage completion:(void (^)(id, NSError *))completion{
    
        
        //创建分享消息对象
        UMSocialMessageObject * messageObject = [UMSocialMessageObject messageObject];
        
    
        
        UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumImage];
        
        // 设置网地址
        shareObject.webpageUrl = url;
        
        // 设置分享内容
        
        messageObject.shareObject = shareObject;
    
    
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        // 调用分享接口
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id result, NSError *error) {
            
            if (error) {
                
                NSLog(@"%@",error);
                
            }else {
                
                if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                    
                    UMSocialShareResponse *resp = result;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                    if (completion) {
                        completion(result,error);
                    }
                }else {
                    
                    UMSocialLogInfo(@"response data is %@",result);
                }
            }
        }];

}

@end
