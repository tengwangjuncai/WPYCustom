//
//  IGMacro.h
//  ImGuider
//
//  Created by llt on 2017/6/14.
//  Copyright © 2017年 imguider. All rights reserved.
//

#ifndef IGMacro_h
#define IGMacro_h

//----------------------------key--------------------------------------------------------
//通知
#define kDownloadCompleteDownNotif @"kHasCompleteDownNotif" // 下载完成或失败发送通知
#define kDownloadNotifLineID @"kDownloadNotifLineID" // 存储lineID 的key
#define kDownloadState @"kDownloadState" //State 的key
#define kLogoutKey @"kLogoutKey" // 退出登录

#define kFirstOpenListenNetworking @"firstOpenListenNetworking" // 第一次打开应用 允许网络监听

#define kPlayManagerState @"kPlayManagerState"
#define kCurrentPlayURL @"CurrentPlayURL"

// 程序URL
#define kBaseURLStr @"http://192.168.6.186/tourist/services/"// 测试
//#define kBaseURLStr @"https://www.imguider.com/tourist/services/"
//#define kBaseURLStr @"http://domestic.imguider.com/tourist/services/"
//#define kBaseURLStr @"http://35.157.2.119:8180/tourist/services/"

#define kRedirectURL @"https://www.imguider.com"

//缓存key
#define kPath_ImageCache @"ImageCache"// 图片
#define kPath_ResponseCache @"ResponseCache"// 请求
#define DB_NAME @"DataBase"// 数据库
#define kKeychainService @"ImGuider"
#define kRecommenCacpePath @"RcommenCacpePath"

// appkey
#define UMENG_APPKEY @"58fed511f29d983427000404"// 友盟
#define BUGLY_APPID @"91b6c2d6ae"//bugly

// ---------------------------第三方登录、支付
#define UMENG_FB_APPID @"296422350804944"

#define UMENG_QQ_APPID @"1106076593"

#define UMENG_WB_APPKEY @"467068712"
#define UMENG_WB_APPSECRET @"edadefd1f9257d99ac0d5ff537767bd6"

#define UMENG_WX_APPID @"wxa64da1c01dc0c905"
#define UMENG_WX_APPSECRET @"a3542e4471088b5dcaf1c49f538121a4"

#define PAYPAL_SANDBOX_CLIENTID @"AahuzZ-yGAUntngQP38OmHKl-G6pFNSiw90sHavDXXS3eKwH3ddTBGQW_p5A4HH-ZoQpKlgKE7f9A71d"

#define PAYPAL_LIVE_CLIENTID @"AYj3_zqirtdT7532eWapveyLgleI-QHGqgC7ZVjg0WdoUIqbF7wKgLokfMr8CDJ7YKNmrtNCUonEgxT-"


#define MW_KEY @"69RI29N8WBU179JRY0GJQCT2G7815BMD"

//----------------------------颜色--------------------------------------------------------
#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define BLUE_COLOR          [UIColor colorWithHex:0xFF2C9AFE]
#define LINE_BG_COLOR       [UIColor colorWithHex:0xFFE3E3E3]
#define TABBAR_FONT         [UIFont systemFontOfSize:11]
#define LIGHT_GRAY_COLOR    [UIColor colorWithHex:0xFF999999]

#define kThemeColor RGB(50,179,198)
#define kThemeDarkColor RGB(32,123,177)
#define kThemeLightColor RGB(50,179,198)
#define kThemeRedColor RGB(230,68,97)

#define kTitleColor RGB(29,29,29)
#define kSubitleColor RGB(90,90,90)
#define kContentColor RGB(150,150,150)

#define kBGColor [UIColor groupTableViewBackgroundColor]

//----------------------------字体--------------------------------------------------------
#define FontBold(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]

//----------------------------高度--------------------------------------------------------
// 获取屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 字体行间距

#define lineSpace  8
// 定义导航条和tabbar高度
#define kNavigationBarHeight 64
#define kTableBarHeight 49

// 地图默认缩放级别
#define kZoomLevel 13

//-------------------------版本号------------------------------------------------------------
#define kVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

// 定义iPhone版本
#define ISiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPad  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad

//判断当前系统版本号
#ifndef kSystemVersion
#define kSystemVersion [[UIDevice currentDevice] systemVersion].floatValue
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

#ifndef kiOS10Later
#define kiOS10Later (kSystemVersion >= 10)
#endif

//判

//-------------------------IGLog------------------------------------------------------------
#ifdef DEBUG
#define IGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define IGLog(...)

#endif

//-------------------------weakify------------------------------------------------------------
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* IGMacro_h */
