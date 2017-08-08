//
//  progressView.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/7/19.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "progressView.h"


@interface progressView()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAShapeLayer * progressBackgroundLayer;

@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) BOOL isSpinning;

@property (nonatomic, strong) UIColor * progressColor;
@end
@implementation progressView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}



-(void)setup {
    
    _lineWidth = fmaxf(self.frame.size.width * 0.025, 1.f);
    _progressColor = [UIColor colorWithRed:39/255.0 green:178/255.0 blue:197/255.0 alpha:1.0];
   
    self.progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
    _progressBackgroundLayer.strokeColor = _progressColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressBackgroundLayer];
    
    [self.layer addSublayer:self.progressLayer];
    
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.contentsScale = [[UIScreen mainScreen] scale];
        _progressLayer.strokeColor = _progressColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapSquare;
        _progressLayer.lineWidth = _lineWidth * 1.0;
    }
    
    return  _progressLayer;
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        
        
        [self setNeedsDisplay];
    }
}


- (void) drawBackgroundCircle:(BOOL) partial {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    // Recompute the end angle to make it at 90% of the progress
    if (partial) {
        endAngle = (1.8F * (float)M_PI) + startAngle;
    }
    
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}


- (void) stopSpinProgressBackgroundLayer {
    [self drawBackgroundCircle:NO];
    [_progressBackgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}
- (void)drawRect:(CGRect)rect
{
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    //_iconLayer.frame = self.bounds;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    [self drawBackgroundCircle:_isSpinning];
    
    // Draw progress
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    // CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = _lineWidth;
    
    radius = (self.bounds.size.width - _lineWidth*3) / 2.0;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [_progressLayer setPath:processPath.CGPath];
    
//    switch (_circularState) {
//        case FFCircularStateStop:
//            [self drawStop];
//            break;
//            
//        case FFCircularStateStopSpinning:
//            [self drawStop];
//            break;
//            
//        case FFCircularStateStopProgress:
//            [self drawStop];
//            break;
//            
//        case FFCircularStateCompleted:
//            [self drawTick];
//            break;
//            
//        case FFCircularStateIcon:
//            if (!self.iconView && !self.iconPath){
//                [self drawArrow];
//            }
//            else if (self.iconPath){
//                _iconLayer.path = self.iconPath.CGPath;
//                _iconLayer.fillColor = nil;
//            }
//            break;
//            
//        default:
//            break;
//    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
