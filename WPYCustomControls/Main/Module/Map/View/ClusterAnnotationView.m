//
//  ClusterAnnotationView.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/8/1.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

//
//  ClusterAnnView.m
//  ImGuider
//
//  Created by llt on 2017/7/13.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import "ClusterAnnotationView.h"
#import "IGUtils.h"
@interface ClusterAnnotationView ()

@property (nonatomic, strong) UIButton *countBtn;

@end

@implementation ClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.backgroundColor = kThemeColor;
        _countBtn.titleLabel.font = Font(12);
        
        _countBtn.layer.borderWidth = 2.0f;
        _countBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _countBtn.layer.shadowOffset = CGSizeZero;
        _countBtn.layer.shadowOpacity = 0.4;
        _countBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        [self addSubview:_countBtn];
        
        
//                _label.layoutMargins = UIEdgeInsetsMake(5, 5, 5, 5);
//        
//        
//                [_label sizeToFit];
//        
//        
//        
//                [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//                    make.height.equalTo(make.width);
//                }];
    }
    return self;
}


- (void)setCountStr:(NSString *)countStr {
    
    CGFloat width = [IGUtils getSizeContent:countStr width:100 font:Font(12)].width + 30;
    
    [self.countBtn setTitle:countStr forState:UIControlStateNormal];
    
    @weakify(self);
    [self.countBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
        make.center.equalTo(self);
    }];
    
    self.countBtn.layer.cornerRadius = width / 2.0f;
}




@end

