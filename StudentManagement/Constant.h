//
//  Constant.h
//  StudentManagement
//
//  Created by Kitty on 17/2/15.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define BaseURL                     @"http://ebj.zhi-watch.com"
#define OpenHomeworkNotification    @"openHomework"
#define SubjectFileName             [NSHomeDirectory() stringByAppendingPathComponent:@"subject.src"]

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

typedef enum : NSUInteger {
    FolderTypeImport,
    FolderTypeOut,
    FolderTypeUpload,
    FolderTypeOpen,
    FolderTypeDelete
} FolderType;

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//设置RGB颜色值
#define SETCOLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

#define KColor  [ColorTools colorWithHexString:@"#1CBA3C"]
// 每个View背景色值
#define KblackgroundColor  [ColorTools colorWithHexString:@"#F0F0F0"]
// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#f9f9f9"]
// button背景颜色
#define ButtonBgColor  [ColorTools colorWithHexString:@"#1CBA3C"]


// 应用程序托管
#define AppDelegateInstance	 ((AppDelegate*)([UIApplication sharedApplication].delegate))

#if DEBUG
#define DLog(...) NSLog(__VA_ARGS__);
#define DLog_METHOD NSLog(@"%s", __func__)
#define DLogERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#else
#define DLog(format,...)
#endif

// com.idolly.smartChildCloth
#define GaoDeAPIKey     @"c7e2edf474d59bbd582b7ac506c1ad89"

#define kGtAppId        @"Xbjt90sodaArq5BLyJspi1"
#define kGtAppKey       @"fXL1REMzoM7aU7F5T7nBJ2"
#define kGtAppSecret    @"yDKNhDiBW27Fp1OvfGc4BA"
#define kGtMasterSecret @"XpSZ4oBACT9DhBT5WSSns4"

#endif /* Constant_h */
