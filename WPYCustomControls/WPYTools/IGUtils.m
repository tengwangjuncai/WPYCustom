//
//  IGUtils.m
//  ImGuider
//
//  Created by llt on 2017/4/11.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import "IGUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <Accelerate/Accelerate.h>


@implementation IGUtils

//+ (void)showToast:(NSString *)toast {
//    
//    if ([toast isKindOfClass:[NSString class]] && toast.length > 0) {
//        
//        CGFloat time = 1;
//        
//        NSInteger multiple = ceil(toast.length / 25.0f);
//        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
//        hud.detailsLabel.text = toast;
//        hud.margin = 10.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hideAnimated:YES afterDelay:time * multiple];
//    }
//}


// ---------------------------------------------坐标转换-----------------------------------
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D) latLng {
    double wgLat = latLng.latitude;
    double wgLon = latLng.longitude;
    double mgLat;
    double mgLon;
    
    if ([self outOfChina:wgLat :wgLon ])
    {
        return latLng;
    }
    double dLat = [self transformLat:wgLon-105.0 :wgLat - 35 ];
    double dLon = [self transformLon:wgLon-105.0 :wgLat - 35 ];
    
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    CLLocationCoordinate2D loc2D ;
    loc2D.latitude = mgLat;
    loc2D.longitude = mgLon;
    
    return loc2D;
}

#pragma mark private
+ (BOOL) outOfChina:(double) lat :(double) lon {
    if (lon < 72.004 || lon > 137.8347) {
        return true;
    }
    if (lat < 0.8293 || lat > 55.8271) {
        return true;
    }
    return false;
}

+ (double) transformLat:(double)x  :(double) y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y +
    0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x *M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 *sin(y / 3.0 *M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 *sin(y * M_PI / 30.0)) * 2.0 /
    3.0;
    return ret;
}

+ (double) transformLon:(double) x :(double) y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 *M_PI) + 300.0 *sin(x / 30.0 * M_PI)) * 2.0 /
    3.0;
    return ret;
}

+ (CGFloat)getDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoor toCoordinate:(CLLocationCoordinate2D)toCoor {
    
    CLLocation *fromLoc = [[CLLocation alloc] initWithLatitude:fromCoor.latitude longitude:fromCoor.longitude];
    CLLocation *toLoc = [[CLLocation alloc] initWithLatitude:toCoor.latitude longitude:toCoor.longitude];
    
    return [fromLoc distanceFromLocation:toLoc];
}

+ (CGSize )getTriangleWithangle:(CGFloat)angle hypotenuse:(CGFloat)hypotenuse {
    
    CGFloat mathAngle = angle * M_PI / 180.0f;
    
    CGFloat y = hypotenuse * sinf(mathAngle);
    CGFloat x = hypotenuse * cosf(mathAngle);
    
    
    return CGSizeMake(x, y);
}


//+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
//{
//    if (!image)
//    {
//        IGLog(@"error:为图片添加模糊效果时，未能获取原始图片");
//        return nil;
//    }
//    if (blur < 0.f || blur > 1.f) {
//        blur = 0.5f;
//    }
//    int boxSize = (int)(blur * 40);
//    boxSize = boxSize - (boxSize % 2) + 1;
//    CGImageRef img = image.CGImage;
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    void *pixelBuffer;
//    //从CGImage中获取数据
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    //设置从CGImage获取对象的属性
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    if(pixelBuffer == NULL)
//        IGLog(@"No pixelbuffer");
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    if (error) {
//        IGLog(@"error from convolution %ld", error);
//    }
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    //clean up CGContextRelease(ctx);
//    CGColorSpaceRelease(colorSpace);
//    free(pixelBuffer);
//    CFRelease(inBitmapData);
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
//    return returnImage;
//}

//+ (UIImage *)blurryImage:(UIImage *)image withMaskImage:(UIImage *)maskImage blurLevel:(CGFloat)blur {
//    
//    // 创建属性
//    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
//    
//    // 滤镜效果 高斯模糊
//    //    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    //    [filter setValue:cimage forKey:kCIInputImageKey];
//    //    // 指定模糊值 默认为10, 范围为0-100
//    //    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
//    
//    /**
//     *  滤镜效果 VariableBlur
//     *  此滤镜模糊图像具有可变模糊半径。你提供和目标图像相同大小的灰度图像为它指定模糊半径
//     *  白色的区域模糊度最高，黑色区域则没有模糊。
//     */
//    CIFilter *filter = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
//    // 指定过滤照片
//    [filter setValue:ciImage forKey:kCIInputImageKey];
//    CIImage *mask = [CIImage imageWithCGImage:maskImage.CGImage] ;
//    // 指定 mask image
//    [filter setValue:mask forKey:@"inputMask"];
//    // 指定模糊值  默认为10, 范围为0-100
//    [filter setValue:[NSNumber numberWithFloat:blur] forKey: @"inputRadius"];
//    
//    // 生成图片
//    CIContext *context = [CIContext contextWithOptions:nil];
//    // 创建输出
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    
//    // 下面这一行的代码耗费时间内存最多,可以开辟线程处理然后回调主线程给imageView赋值
//    //result.extent 指原来的大小size
//    //    IGLog(@"%@",NSStringFromCGRect(result.extent));
//    //    CGImageRef outImage = [context createCGImage: result fromRect: result.extent];
//    
//    CGImageRef outImage = [context createCGImage: result fromRect:CGRectMake(0, 0, 320.0 * 2, 334.0 * 2)];
//    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
//    
//    return blurImage;
//}


//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSInteger)totalTime {
    
    NSInteger seconds = totalTime;
    
    NSInteger hour = seconds / 3600;
    NSInteger minute = (seconds % 3600) / 60;
    NSInteger second = seconds % 60;
    
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",minute];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",second];
    
    NSString *format_time = nil;
    if (hour > 0) {
        
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
    
}

+ (NSString *)md5:(NSString *)string {
    
    
    if (string.length == 0) {
        return nil;
    }
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return [result lowercaseStringWithLocale:[NSLocale currentLocale]];
}


+ (CGFloat)getHeightWithText:(NSString*)text width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font  defaultHeight:(CGFloat *)height {
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    label.numberOfLines = 0;
    
    label.attributedText = [self attributedStringText:text font:font color:kContentColor lineSpacing:lineSpacing];
    
    CGSize totalSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    label.numberOfLines = 3;
    CGSize defaultSize = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    *height = defaultSize.height;
    
    return totalSize.height;
}

+ (CGSize)getSizeContent:(NSString *)content width:(CGFloat)width font:(UIFont *)font {
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = 0;
    
    label.text = content;
    label.font = font;
    
    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

+ (NSMutableAttributedString *)attributedStringText:(NSString*)text font:(UIFont *)font color:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing {
    if (!text) {
        return [NSMutableAttributedString new];
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.lineSpacing = lineSpacing;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:textColor
                                 };
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}


+ (BOOL)isStringLenght0:(NSString *)string {
    
    NSString *myString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (myString.length == 0) {
        return YES;
    }
    return NO;
}

// 网络请求失败 中的失败处理

//+ (NSString *)tipFromError:(NSError *)error {
//    
//    if (error && error.userInfo) {
//        
//        NSString *errStr = nil;
//        
//        if ([error.userInfo objectForKey:@"errmsg"]) {
//            
//            errStr = [error.userInfo objectForKey:@"errmsg"];
//        } else if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
//            
//            errStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];//NSLocalizedDescription
//        } else if ([error.userInfo objectForKey:@"message"]) {
//            
//            id msg = [error.userInfo objectForKey:@"message"];
//            
//            if ([msg isKindOfClass:[NSDictionary class]]) {
//                errStr = msg[@"error"];
//            } else if ([msg isKindOfClass:[NSString class]]) {
//                errStr = msg;
//            }
//            
//        } else if ([error.userInfo objectForKey:@"messsage"]) {
//            
//            errStr = [error.userInfo objectForKey:@"messsage"];
//            
//        }  else if ([error.userInfo objectForKey:@"msg"]) {
//            
//            errStr = [error.userInfo objectForKey:@"msg"];
//        } else {
//            
//            
//            id myError = error.userInfo[@"NSUnderlyingError"];
//            NSDictionary *dict = myError;
//            if ([myError isKindOfClass:[NSError class]]) {
//                dict = ((NSError *)myError).userInfo;
//            }
//            
//            if ([dict isKindOfClass:[NSDictionary class]]) {
//                errStr = [dict objectForKey:@"NSLocalizedDescription"];
//            }
//            if (errStr.length == 0) {
//                errStr = MYLocalizedString(@"PUBLIC_SYSTEM_ERROR", nil);
//            }
//        }
//        
//        return errStr;
//    }
//    return nil;
//}

+ (NSString *)changeFileSize:(NSUInteger)fileSize {
    
    NSString *sizeText = nil;
    
    if (fileSize >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", fileSize / pow(10, 9)];
    } else if (fileSize >= pow(10, 6)) { // 1GB > size >= fileSize
        sizeText = [NSString stringWithFormat:@"%.2fMB", fileSize / pow(10, 6)];
    } else if (fileSize >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", fileSize / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", fileSize];
    }
    
    
    return sizeText;
}

+ (id)loadViewController:(NSString *)identifier storyboard:(NSString *)sb {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:sb bundle:[NSBundle mainBundle]];
    
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:identifier];
    
    return vc;
}

+ (UIViewController *)currentViewController {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


+ (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity WithColor:(UIColor *)color
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowColor = color.CGColor;//[UIColor blackColor].CGColor;//
    view.layer.shadowOpacity = shadowOpacity;
}

+ (UIImage*) getImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (BOOL)isEmoji:(NSString *)string {
    
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}


//+ (void)tractficToLocation:(CLLocationCoordinate2D )tolocation vc:(UIViewController *)vc {
//    
//    NSArray *mapArray = [self getUserableMapArray];
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // app名称
//    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSString *urlScheme = @"imguider://";
//    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    for (NSDictionary *dict in mapArray) {
//        
//        UIAlertAction *action = [UIAlertAction actionWithTitle:MYLocalizedString(dict[@"name"], nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            switch ([dict[@"tag"] integerValue]) {
//                case 0: {//苹果地图
//                    
//                    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//                    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:tolocation addressDictionary:nil]];
//                    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
//                                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
//                }
//                    break;
//                case 1: {//百度地图
//                    
//                    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",tolocation.latitude, tolocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//                }
//                    break;
//                case 2: {//谷歌地图
//                    
//                    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,tolocation.latitude, tolocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//                }
//                    break;
//                case 3: {//高德地图
//                    
//                    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,tolocation.latitude, tolocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//        }];
//        [alertVC addAction:action];
//    }
//    [alertVC addAction:[UIAlertAction actionWithTitle:MYLocalizedString(@"PUBLIC_CANCEL", nil) style:UIAlertActionStyleCancel handler:nil]];
//    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
//    
//    if (popover) {
//        
//        popover.sourceView = vc.view;
//        popover.sourceRect = vc.view.bounds;
//        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    }
//    
//    [vc presentViewController:alertVC animated:YES completion:nil];
//}
//

+ (NSArray *)getUserableMapArray {
    
    NSArray *allMapArray = @[@{@"name":@"MAP_APPLE",@"url":@"",@"tag":@(0)},@{@"name":@"MAP_BAIDU",@"url":@"baidumap://",@"tag":@(1)},@{@"name":@"MAP_GOOGLE",@"url":@"comgooglemaps://",@"tag":@(2)},@{@"name":@"MAP_GAO",@"url":@"iosamap://",@"tag":@(3)}];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:allMapArray];
    
    for (int i = 0; i < allMapArray.count; i ++) {
        
        NSDictionary *dict = allMapArray[i];
        
        NSString *url = dict[@"url"];
        
        if (!url) {
            continue;
        }
        
        if (url.length > 0) {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                
                [resultArray removeObject:dict];
                
                IGLog(@"-----%@",dict[@"name"]);
            }
        }
    }
    
    return resultArray;
}



@end
