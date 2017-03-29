//
//  FileHelper.h
//  StudentManagement
//
//  Created by Kitty on 17/3/29.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件控制
 *
 *  所有文件操作都是在Docments路径下进行的
 */

@interface FileHelper : NSObject

+ (instancetype)sharedFileManager;

/**
 *  创建文件夹
 *
 *  @param dir 文件夹名
 */
+ (BOOL)createDir:(NSString *)documentsPath DirStr:(NSString *)dir;

/**
 *  创建文件
 *
 *  @param fileName 文件名
 */
+ (void)createFile:(NSString *)fileName AtPath:(NSString *)documentsPath;

/**
 *  根据文件名删除文件
 *
 *  @param fileName 文件名
 */
+ (void)removeFileWithFileName:(NSString *)fileName;

// 写文件
+ (BOOL)writeFile:(NSString *)filePath text:(NSString *)content;

// 读文件
+ (NSString *)readFile:(NSString *)filePath;

//文件属性
+ (NSArray *)fileAttriutes:(NSString *)filePath;

/**
 *  将数据存到指定的文件夹中
 *
 *  @param data     要保存的数据
 *  @param name     保存的文件名（要加后缀名。例如“文件.txt”）
 *  @param fileName 保存文件夹
 *
 *  @return 成功返回YES 失败返回NO
 */
+(BOOL)saveData:(NSData *)data withName:(NSString *)name andPath:(NSString *)fileName;

/**
 *  清除缓存
 */
+(void)clearCaches;

@end
