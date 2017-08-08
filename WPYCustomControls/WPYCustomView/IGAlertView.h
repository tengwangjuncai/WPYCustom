//
//  IGAlertView.h
//  ImGuider
//
//  Created by llt on 2017/4/25.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGAlertView : UIAlertView

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancelTitle commitBtn:(NSString *)commitTitle commit:(void (^) ())commit cancel:(void (^) ())cancel;

+ (void)threeBtnAlertWithTitle:(NSString *)title message:(NSString *)message firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle thirdBtnTitle:(NSString *)thirdTitle firstBlock:(void (^) ())first secondBlock:(void (^) ())second thirdBlock:(void (^) ())third;
@end
