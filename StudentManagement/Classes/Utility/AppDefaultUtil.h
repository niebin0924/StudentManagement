//
//  AppDefaultUtil.h
//  ChildCloth
//
//  Created by Kitty on 16/8/19.
//  Copyright © 2016年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDefaultUtil : NSObject


/**
 单例模式，实例化对象
 */
+ (instancetype)sharedInstance;

- (void)setPhotoLibary:(BOOL)isPhoto;
- (BOOL)isPhotoLibary;

- (void)setToken:(NSString *)token;
- (NSString *)getToken;

- (void)setFirstLanuch:(BOOL)isFirst;
- (BOOL)getFirstLanuch;

// 设置是否记住密码
-(void)setRemeberUser:(BOOL)value;
// 获取用户是否记住密码
-(BOOL)isRemeberUser;

- (void)setAccount:(NSString *)account;
- (NSString *)getAccount;

- (void)setPwd:(NSString *)password;
- (NSString *)getPwd;

- (void)setStuentId:(NSString *)studentId;
- (NSString *)getStudentId;

// 保存当前图像
- (void)setHeadImageUrl:(NSString *)headUrl;
- (NSString *)getHeadImageUrl;

// 保存当前真实姓名
- (void)setRealName:(NSString *)realName;
- (NSString *)getRealName;

- (void)setSchoolName:(NSString *)schoolName;
- (NSString *)getSchoolName;

- (void)setGradeName:(NSString *)gradeName;
- (NSString *)getGradeName;

//- (void)setSubjects:(NSArray *)subjects;
//- (NSArray *)getSubjects;

@end
