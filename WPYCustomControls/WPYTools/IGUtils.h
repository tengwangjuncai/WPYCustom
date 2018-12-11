//
//  IGUtils.h
//  ImGuider
//
//  Created by llt on 2017/4/11.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface IGUtils : NSObject

/**
 显示toast

 @param toast 要显示的文字
 */
+ (void)showToast:(NSString *)toast;

/**
 *  public:原生地图获取坐标转化为真实坐标
 *
 *  @param latLng 原生坐标点
 *
 *  @return 真实坐标点
 */
+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D) latLng;


/**
 根据直角三角形角度和斜边，求出另外两个边
 e.g.:传人 30，2 返回 1，1.732

 @param angle 角度 例如：30
 @param hypotenuse 斜边长度
 @return x,y组成的size
 */
+ (CGSize )getTriangleWithangle:(CGFloat)angle hypotenuse:(CGFloat)hypotenuse;


/**
 获取两点之间的距离

 @param fromCoor 起点位置
 @param toCoor 终点位置
 @return 距离
 */
+ (CGFloat)getDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoor toCoordinate:(CLLocationCoordinate2D)toCoor;


//图片模糊处理
//+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
//
//
//+ (UIImage *)blurryImage:(UIImage *)image withMaskImage:(UIImage *)maskImage blurLevel:(CGFloat)blur;


/**
 根据传入的时间（秒数）获取时分秒（3:43）

 @param totalTime （223）
 @return （3:43）
 */
+ (NSString *)getMMSSFromSS:(NSInteger)totalTime;



/**
 md5

 @param string --
 @return --
 */
+ (NSString *)md5:(NSString *)string;

/**
 获取label高度 （此处为用了下面方法后获取高度的）
 
 @param text --
 @param width --
 @param lineSpacing 行间距
 @param font --
 @param height 获取默认高度 &height
 @return --
 */
+ (CGFloat)getHeightWithText:(NSString*)text width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font  defaultHeight:(CGFloat *)height;

/**
 将文字 行间距 换成NSAttributedString

 @param text --
@param font --
 @param lineSpacing 行间距
 @return --
 */
+ (NSMutableAttributedString *)attributedStringText:(NSString*)text font:(UIFont *)font color:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing;


/**
 获取尺寸

 @param content 内容
 @param width 最大宽度
 @param font 字体
 @return 尺寸
 */
+ (CGSize)getSizeContent:(NSString *)content width:(CGFloat)width font:(UIFont *)font;


/**
 判断输入是否为“”

 @param string --
 @return --
 */
+ (BOOL)isStringLenght0:(NSString *)string;


/**
 获取错误的字符串

 @param error 错误信息
 @return 错误字符串
 */
+ (NSString *)tipFromError:(NSError *)error;


/**
 文件大小转换

 @param fileSize 文件大小
 @return --
 */
+ (NSString *)changeFileSize:(NSUInteger)fileSize;

+ (UIViewController *)currentViewController;

+ (id)loadViewController:(NSString *)identifier storyboard:(NSString *)sb;
/**
 
 给View  添加阴影 （imageView  不能添加）
 
 **/

+ (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity WithColor:(UIColor *)color;

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height;


/**
 判断字段是否包含Emoji表情

 @param string --
 @return --
 */
+ (BOOL)isEmoji:(NSString *)string;

/**
 打开外部地图，导航到location

 @param tolocation location
 @param vc 当前vc
 */
+ (void)tractficToLocation:(CLLocationCoordinate2D )tolocation vc:(UIViewController *)vc;



@end
