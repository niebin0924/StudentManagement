//
//  AppDelegate.m
//  StudentManagement
//
//  Created by Kitty on 17/2/15.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GuideViewController.h"
#import "LoginViewController.h"
#import "AdViewController.h"
#import "AdvertiseView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    NSLog(@"homeDirectory=====%@",NSHomeDirectory());
    
    // 当网络请求的时候，状态栏上的小菊花就会开始转
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        //iPad 版本代码
    }
    else{
        //iPhone/iPod touch 版本代码
    }
    
    BOOL isFirst = [[AppDefaultUtil sharedInstance] getFirstLanuch];
    if (!isFirst) {
        
        [[AppDefaultUtil sharedInstance] setFirstLanuch:YES];
        [[AppDefaultUtil sharedInstance] setRemeberUser:YES];
        
        GuideViewController *guideVC = [[GuideViewController alloc]init];
        self.window.rootViewController = guideVC;
        [self.window makeKeyAndVisible];
        
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
   
    // 如果需要更新
//    AdViewController *vc = [[AdViewController alloc] init];
//    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:vc];
//    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    /*
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
     */
    
    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
    advertiseView.filePath = @"page_pic01";
    [advertiseView show];
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];

    return YES;
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application
//supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        return UIInterfaceOrientationMaskAll;
//    else  /* iPad */
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
