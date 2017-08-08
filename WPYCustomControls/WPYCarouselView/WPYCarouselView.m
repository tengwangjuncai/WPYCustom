//
//  WPYCarouselView.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/5/9.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "WPYCarouselView.h"

@interface WPYCarouselView()

@property (nonatomic, strong)UIView * hideView;
@property (nonatomic, strong)UIView * currentView;

@property (nonatomic, strong)NSTimer * timer;
@end



@implementation WPYCarouselView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _currentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width - 20, frame.size.height - 10)];
        _currentView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_currentView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:_currentView.bounds];
        label.text = @"    你好 乔桑";
        [_currentView addSubview:label];
        
        _hideView = [[UIView alloc] initWithFrame:CGRectMake(10,self.frame.size.height, frame.size.width - 20, frame.size.height - 10)];
        _hideView.backgroundColor = [UIColor greenColor];
        [self addSubview:_hideView];
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantPast]];
        [self setAnchorPointTo:CGPointMake(0.5, 0.5) withView:_currentView];
        [self setAnchorPointTo:CGPointMake(0.5, 0.5) withView:_hideView];
        
       
    }
    return self;
}



- (void)setAnchorPointTo:(CGPoint)point withView:(UIView *)View{
    View.frame = CGRectOffset(View.frame, (point.x - View.layer.anchorPoint.x) * View.frame.size.width, (point.y - View.layer.anchorPoint.y) * View.frame.size.height);
    View.layer.anchorPoint = point;
}

- (void)changeView {
    
    
    [UIView animateWithDuration:1 animations:^{
     _hideView.frame = CGRectMake(10, 5,self.frame.size.width - 20, self.frame.size.height - 10);
        
        _currentView.frame = CGRectMake(20,-10,self.frame.size.width - 40, self.frame.size.height - 20);
        _currentView.layer.transform = CATransform3DMakeRotation(- M_PI_2, 1, 0, 0);
        //_currentView.alpha = 0.;
    } completion:^(BOOL finished) {
        
        _currentView.layer.transform = CATransform3DIdentity;
        _currentView.frame = CGRectMake(10,self.frame.size.height,self.frame.size.width - 20, 0);
       // _currentView.alpha = 1;
        UIView * view = _currentView;
        _currentView = _hideView;
        _hideView = view;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
