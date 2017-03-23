//
//  AppDefaultUtil.m
//  ChildCloth
//
//  Created by Kitty on 16/8/19.
//  Copyright © 2016年 Kitty. All rights reserved.
//

#import "AppDefaultUtil.h"

#define KEY_FIRSTLANUCH     @"FirstLaunch"
#define KEY_TOKEN           @"Token"
#define KEY_REMEBER_USER    @"RemeberUser"

#define KEY_PHOTO           @"PhotoLibary"

#define KEY_STUID           @"StudentId"

#define KEY_ACCOUNT         @"Account"    // 平台账号/手机号
#define KEY_PWD             @"Password"
#define KEY_HEARD_IMAGE     @"HeadImage"  //头像
#define KEY_REALNAME        @"RealName"   // 真实姓名
#define KEY_SCHOOL          @"SchoolName" // 学校
#define KEY_GRADE           @"GradeName"  // 年级

#define KEY_SUBJECTES       @"Subjects"


@implementation AppDefaultUtil

+ (instancetype)sharedInstance {
    
    static AppDefaultUtil *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AppDefaultUtil alloc] init];
        
    });
    
    return _sharedClient;
}

- (void)setPhotoLibary:(BOOL)isPhoto
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isPhoto forKey:KEY_PHOTO];
    [defaults synchronize];
}

- (BOOL)isPhotoLibary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_PHOTO];
}

- (void)setFirstLanuch:(BOOL)isFirst
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isFirst forKey:KEY_FIRSTLANUCH];
    [defaults synchronize];
}

- (BOOL)getFirstLanuch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_FIRSTLANUCH];
}

// 设置是否记住密码
-(void) setRemeberUser:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:KEY_REMEBER_USER];
    [defaults synchronize];
}

-(BOOL) isRemeberUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_REMEBER_USER];
}

- (void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:KEY_TOKEN];
    [defaults synchronize];
}

- (NSString *)getToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_TOKEN];
}

- (void)setAccount:(NSString *)account
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:KEY_ACCOUNT];
    [defaults synchronize];
}

- (NSString *)getAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_ACCOUNT];
}

- (void)setPwd:(NSString *)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:KEY_PWD];
    [defaults synchronize];
}

- (NSString *)getPwd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_PWD];
}

- (void)setStuentId:(NSString *)studentId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:studentId forKey:KEY_STUID];
    [defaults synchronize];
}

- (NSString *)getStudentId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_STUID];
}

- (void)setHeadImageUrl:(NSString *)headUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:headUrl forKey:KEY_HEARD_IMAGE];
    [defaults synchronize];
}

- (NSString *)getHeadImageUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_HEARD_IMAGE];
}



- (void)setRealName:(NSString *)realName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:realName forKey:KEY_REALNAME];
    [defaults synchronize];
}

- (NSString *)getRealName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_REALNAME];
}

- (void)setSchoolName:(NSString *)schoolName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:schoolName forKey:KEY_SCHOOL];
    [defaults synchronize];
}

- (NSString *)getSchoolName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_SCHOOL];
}

- (void)setGradeName:(NSString *)gradeName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:gradeName forKey:KEY_GRADE];
    [defaults synchronize];
}

- (NSString *)getGradeName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_GRADE];
}

- (void)setSubjects:(NSArray *)subjects
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:subjects forKey:KEY_SUBJECTES];
    [defaults synchronize];
}

- (NSArray *)getSubjects
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:KEY_SUBJECTES];
}

@end
