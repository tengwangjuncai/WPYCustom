//
//  ViewAnnView.h
//  ImGuider
//
//  Created by llt on 2017/6/23.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IGAnnotation.h"
#import <kingpin/kingpin.h>

@protocol ViewAnnViewDelegate;

@interface ViewAnnView : MKAnnotationView

@property (nonatomic, weak) id <ViewAnnViewDelegate> delegate;

@property (nonatomic, copy) void (^ clickScenicViewBlock) ();

- (void)showCallView;

@end

@protocol ViewAnnViewDelegate <NSObject>

@required

/**
 点击弹出按钮时调用
 
 @param pin KPAnnotation对象
 @param btnType 按钮类型 Tractfic 交通，Intro 简介
 */
//- (void)annotationView:(KPAnnotation *)pin clickBtn:(ClickBtnType) btnType;


// 点击划线

- (void)tapAddLineWithPoint:(CLLocationCoordinate2D )coordinate;
@end
