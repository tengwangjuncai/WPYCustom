//
//  IGAnnotation.h
//  ImGuider
//
//  Created by llt on 2017/4/14.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface IGAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *imageURLStr;

@property (nonatomic, strong) NSString *number;// 编号
@property (nonatomic) NSInteger rank;//  热度
@property (nonatomic) NSInteger tag;// 区分不同ann

@end
