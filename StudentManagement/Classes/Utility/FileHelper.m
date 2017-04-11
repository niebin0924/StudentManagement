//
//  FileHelper.m
//  StudentManagement
//
//  Created by Kitty on 17/3/29.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

static FileHelper *shareInstance = nil;
+ (instancetype)sharedFileManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:zone];
    });
    return shareInstance;
}

//获取Documents目录
+ (NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Documents: %@",documentsDirectory);
    return documentsDirectory;
}

// 创建文件夹
+ (BOOL)createDir:(NSString *)documentsPath DirStr:(NSString *)dir
{
    NSString *directryPath = [documentsPath stringByAppendingPathComponent:dir];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:directryPath isDirectory:&isDir] || !isDir) {
        
        BOOL isSuc = [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (isSuc) {
            NSLog(@"创建文件夹成功");
        }else{
            NSLog(@"创建文件夹失败");
        }
        return isSuc;
        
    }else{
        NSLog(@"已创建");
        return NO;
    }
    
}

/**
 *  根据文件名删除文件
 *
 *  @param fileName 文件名
 */
+ (void)removeFileWithFileName:(NSString *)fileName
{
    NSString *removeFile = [self getFileNamePath:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:removeFile]) {
        NSLog(@"文件不存在");
    }else{
        BOOL isSuc = [fileManager removeItemAtPath:removeFile error:nil];
        if (isSuc) {
            [fileManager isExecutableFileAtPath:removeFile];
            NSLog(@"删除文件成功");
        }else{
            NSLog(@"删除文件失败");
        }
        
    }
    
}

// 创建文件
+ (void)createFile:(NSString *)fileName AtPath:(NSString *)documentsPath
{
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        
        BOOL isSuc = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (isSuc) {
            NSLog(@"创建文件成功");
        }else{
            NSLog(@"创建文件失败");
        }
        
    }else{
        NSLog(@"已创建");
    }
}

//写文件
+ (BOOL)writeFile:(NSString *)filePath text:(NSString *)content
{
    return [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
//读文件
+ (NSString *)readFile:(NSString *)filePath
{
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}
//文件属性
+ (NSArray *)fileAttriutes:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    
    return [fileAttributes allKeys];
}

/**
 *  将数据存到指定的文件夹中
 *
 *  @param data     要保存的数据
 *  @param name     保存的文件名（要加后缀名。例如“文件.txt”）
 *  @param fileName 保存文件夹
 *
 *  @return 成功返回YES 失败返回NO
 */
+(BOOL)saveData:(NSData *)data withName:(NSString *)name andPath:(NSString *)fileName
{
    if (data && name && fileName)
    {
        NSString *path = [self getFileNamePath:fileName];
        NSString *targetPath = [path stringByAppendingPathComponent:name];
        
        //纪录目标文件夹中的文件名是否和新的文件名相同（0：表示没有，>0表示已经有了这个文件名）
        NSInteger count = [self judgeTheFileNameIsCreate:fileName andName:name];
        
        if (count == 0)
        {
            return [data writeToFile:targetPath atomically:YES];
        }
        else
        {
            NSLog(@"文件名已经被占用");
        }
    }
    
    return NO;
}

/**
 *  判断要存的文件名是否被使用
 *
 *  @param fileName 文件夹名字
 *  @param name     文件名
 *
 *  @return 数量
 */
+ (NSInteger)judgeTheFileNameIsCreate:(NSString *)fileName andName:(NSString *)name
{
    NSInteger count = 0;
    
    NSArray *fileArray = [self getFileContentWithFileName:fileName];
    if (fileArray.count != 0)
    {
        for (NSString *obj in fileArray)
        {
            //文件名相同的时候count++
            if ([obj isEqualToString:name])
            {
                count++;
            }
        }
    }
    else
    {
        count = 0;
    }
    return count;
}

/**
 *  根据文件名获取该文件下的信息
 *
 *  @param fileName 文件名
 *
 *  @return 该文件夹下所有的文件
 */
+ (NSArray *)getFileContentWithFileName:(NSString *)fileName
{
    
    BOOL isCreate = [self checkTheFileIsCreate:fileName];
    
    if (isCreate) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *array = [fileManager subpathsAtPath:[self getFileNamePath:fileName]];
        
        return array;
    }
    else{
        NSLog(@"没有该文件夹！！！");
    }
    
    
    return nil;
}

/**
 *  查询该文件夹是否被创建
 *
 *  @param fileName 文件夹名
 *
 *  @return 成功返回YES 失败返回NO
 */
+ (BOOL)checkTheFileIsCreate:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [self getFileNamePath:fileName];
    
    BOOL isCreate = NO;
    
    isCreate = [fileManager fileExistsAtPath:filePath];
    
    return isCreate;
}

/**
*   获取指定文件夹里面的路径
*
*  @param fileName 文件夹名
*
*  @return 指定文件夹路径
*/
+(NSString*)getFileNamePath:(NSString*)fileName
{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), fileName];
    
    return path;
}

+(void)clearCaches
{
    //开启后台
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSArray *fileArrays = [[NSFileManager defaultManager] subpathsAtPath:cachesPath];
        
        for(NSString *new in fileArrays)
        {
            NSError *error;
            
            NSString *path = [cachesPath stringByAppendingPathComponent:new];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        NSLog(@"清理成功");
    });
}

@end
