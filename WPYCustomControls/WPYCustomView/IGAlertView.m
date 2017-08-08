//
//  IGAlertView.m
//  ImGuider
//
//  Created by llt on 2017/4/25.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import "IGAlertView.h"

@interface IGAlertView ()
@property (nonatomic, copy) void (^ firstBlock) ();
@property (nonatomic, copy) void (^ secondBlock) ();
@property (nonatomic, copy) void (^ thirdBlock) ();

@end

@implementation IGAlertView

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancelTitle commitBtn:(NSString *)commitTitle commit:(void (^) ())commit cancel:(void (^) ())cancel {
    
    IGAlertView *alertView = [[self alloc] initWithTitle:title message:message cancelButtonTitle:cancelTitle otherButtonTitles:commitTitle, nil];
    
    alertView.secondBlock = commit;
    alertView.firstBlock = cancel;
    
    [alertView show];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    return [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

+ (void)threeBtnAlertWithTitle:(NSString *)title message:(NSString *)message firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle thirdBtnTitle:(NSString *)thirdTitle firstBlock:(void (^) ())first secondBlock:(void (^) ())second thirdBlock:(void (^) ())third {
    
    
    IGAlertView *alertView = [[self alloc] initWithTitle:title message:message cancelButtonTitle:thirdTitle otherButtonTitles:firstTitle,secondTitle, nil];
    
    alertView.firstBlock = third;
    alertView.secondBlock = first;
    alertView.thirdBlock = second;
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        if (self.firstBlock) {
            self.firstBlock();
        }
    }
    
    if (buttonIndex == 1) {
        if (self.secondBlock) {
            self.secondBlock();
        }
    }
    
    if (buttonIndex == 2) {
        if (self.thirdBlock) {
            self.thirdBlock();
        }
    }
}

@end
