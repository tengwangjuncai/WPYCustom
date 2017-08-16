//
//  IGShare.h
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/14.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


@interface IGShare : NSObject

+(void)configIGSharePlatforms;

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withURL:(NSString *)url  Title:(NSString *)title descr:(NSString *)desc thumImage:(id)thumImage completion:(void(^)(id result, NSError *error))completion;
@end
