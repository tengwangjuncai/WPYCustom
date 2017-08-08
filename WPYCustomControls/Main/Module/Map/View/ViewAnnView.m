//
//  ViewAnnView.m
//  ImGuider
//
//  Created by llt on 2017/6/23.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import "ViewAnnView.h"
#import "IGAnnotation.h"
#import <UIImageView+WebCache.h>
#import "IGUtils.h"


typedef NS_ENUM(NSUInteger, ClickBtnType) {
    Tractfic = 1,// 导航
    Intro, // 简介
    Play, // 播放
    PlayWithLine, // 播放并画线
    Select,// 选中
};
@interface ViewAnnView ()

@property (nonatomic) BOOL isShowingCallView;

@property (nonatomic, strong) UIButton *trafficBtn;
@property (nonatomic, strong) UIButton *introBtn;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation ViewAnnView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation"]];
        [self addSubview:self.bgImageView];
        
        @weakify(self);
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _imageView = [[UIImageView alloc] init];
        
        [self.bgImageView addSubview:_imageView];
        
        _imageView.layer.cornerRadius = 20.0f;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _imageView.layer.borderWidth = 1.0f;
        _imageView.clipsToBounds = YES;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.bgImageView.mas_top).offset(1);
            make.left.equalTo(self.bgImageView.mas_left).offset(1);
        }];
    
        _titleLabel = [UILabel new];
        _titleLabel.font = Font(10);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _titleLabel.layer.cornerRadius = 3.0f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.clipsToBounds = YES;
        
        [self addSubview:_titleLabel];
        
        self.centerOffset = CGPointMake(0, -25);
        
        self.canShowCallout = NO;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLine)]];
        
    }
    
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    
    [super setAnnotation:annotation];

    IGAnnotation *ann = (IGAnnotation *)annotation;

    if (!ann || ![ann isKindOfClass:[IGAnnotation class]]) {
        return;
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:ann.imageURLStr] placeholderImage:[UIImage imageNamed:@"placeholder_squ"]];
    self.titleLabel.text = ann.title;
    
    CGFloat titleWidth = [IGUtils getSizeContent:ann.title width:MAXFLOAT font:self.titleLabel.font].width + 10;
    @weakify(self);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(3);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(20);
    }];
}

- (UIButton *)createBtnWithTag:(NSInteger)tag image:(NSString *)imageName {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 40, 40);
    btn.tag = tag;
    btn.layer.cornerRadius = 20;
    btn.titleLabel.font = Font(14);
    btn.backgroundColor = kThemeColor;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return btn;
}

- (UIButton *)trafficBtn {
    
    if (!_trafficBtn) {
        
        _trafficBtn = [self createBtnWithTag:Tractfic image:@"导航"];
    }
    
    return _trafficBtn;
}

- (UIButton *)introBtn {
    
    if (!_introBtn) {
        
       _introBtn = [self createBtnWithTag:Intro image:@"简介"];
    }
    
    return _introBtn;
}

- (void)createCalloutView {
    
    [self addSubview:self.trafficBtn];
    [self addSubview:self.introBtn];
    [self bringSubviewToFront:self.bgImageView];
    
    CGPoint point = self.bgImageView.center;
    
    self.trafficBtn.center = CGPointMake(point.x, point.y - 20);
    self.trafficBtn.transform = CGAffineTransformMakeRotation (- M_2_PI);
    CGPoint newCenter1 = CGPointMake(point.x, point.y - 60);
    
    CGSize size1 = [IGUtils getTriangleWithangle:15 hypotenuse:20];
    CGSize size2 = [IGUtils getTriangleWithangle:15 hypotenuse:55];
    
    self.introBtn.center = CGPointMake(point.x - size1.width, point.y - size1.height);
    self.introBtn.transform = CGAffineTransformMakeRotation (- M_2_PI);
    CGPoint newCenter2 = CGPointMake(point.x - size2.width, point.y - size2.height);
    
    @weakify(self);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        
        self.trafficBtn.center = newCenter1;
        self.trafficBtn.alpha = 1;
        
        self.introBtn.center = newCenter2;
        self.introBtn.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.trafficBtn.transform = CGAffineTransformMakeRotation (0);
        self.introBtn.transform = CGAffineTransformMakeRotation (0);
    }];
}

- (void)dismissCalloutView {
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);

        self.trafficBtn.center = [self viewWithTag:10088].center;
        
        self.introBtn.center = [self viewWithTag:10088].center;
        
        self.trafficBtn.alpha = 0;
        self.introBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        @strongify(self);

        [self.trafficBtn removeFromSuperview];
        [self.introBtn removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.trafficBtn.transform = CGAffineTransformMakeRotation (- M_2_PI);
        self.introBtn.transform = CGAffineTransformMakeRotation (- M_2_PI);
    }];
    
}

- (void)addLine {
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapAddLineWithPoint:)]) {
        [_delegate tapAddLineWithPoint:self.annotation.coordinate];
    }
}

//- (void)btnClick:(UIButton *) btn{
//    [self hiddenCallView];
//    [_delegate annotationView:self.annotation clickBtn:btn.tag];
//}
//
//
//- (void)showCallView {
//    
//    if (self.isShowingCallView) {
//        [self hiddenCallView];
//        return;
//    }
//    
//    self.isShowingCallView = YES;
//    
//    [self createCalloutView];
//    
//    if (self.clickScenicViewBlock) {
//        self.clickScenicViewBlock();
//    }
//}

- (void)hiddenCallView {
    
    if (self.isShowingCallView) {
        
        self.isShowingCallView = NO;
        [self dismissCalloutView];
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside) {
        
        for (UIView *view in self.subviews) {
            
            isInside = CGRectContainsPoint(view.frame, point);
            
            if (isInside) {
                break;
            }
        }
    }
    
    if (!isInside) {
        
        [self hiddenCallView];
    }
    return isInside;
}

//如果监听到点击事件，就用 bringSubviewToFront 方法把self放在接收机的最前面，来接收这个事件。
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil) {
        
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

@end

