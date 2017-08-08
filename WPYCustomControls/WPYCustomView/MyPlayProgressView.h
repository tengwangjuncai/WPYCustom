//
//  MyTestView.h
//  DrawTest
//
//  Created by Mango on 16/6/26.
//  Copyright © 2016年 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPlayProgressViewDelegate <NSObject>
// 开始拖动
- (void)beiginSliderScrubbing;
// 结束拖动
- (void)endSliderScrubbing;
// 拖动值发生改变
- (void)sliderScrubbing;
@end

@interface MyPlayProgressView : UIView

@property (nonatomic, weak) id<MyPlayProgressViewDelegate> delegate;

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat trackValue;
/**
 *  背景颜色：
 playProgressBackgoundColor：播放背景颜色
 trackBackgoundColor ： 缓存条背景颜色
 progressBackgoundColor ： 整个bar背景颜色
 */
@property (nonatomic, strong) UIColor *playProgressBackgoundColor;
@property (nonatomic, strong) UIColor *trackBackgoundColor;
@property (nonatomic, strong) UIColor *progressBackgoundColor;

@property (nonatomic, strong) UIButton *sliderBtn;
@end

@interface MyProgressSliderBtn : UIButton

@end
