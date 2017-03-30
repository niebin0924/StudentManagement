//
//  ImageCache.h
//  JYWebImage
//
//  Created by JourneyYoung on 16/7/28.
//  Copyright © 2016年 JourneyYoung. All rights reserved.
//



/**
 * 缓存池
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCache : NSObject

/**
 * 创建单例
 */
+(ImageCache *)shareInstance;

/**
 * 设置一个内存缓存
 */
@property (nonatomic, retain) NSCache *memoryCache;

/**
 * 设置一个本地缓存
 */
@property (nonatomic, copy) NSString *localCacheDirectory;

/**
 设置本地缓存过期时间，变量的类型是NSTimeInterval,它必须大于或等于零。
 
 如果尝试设置一个负数，结果将被转换为零。
 
 当变量的值不等于0时，清除过期的本地缓存的操作将是应用程序失去焦点时。
 
 默认为10。
 */

@property(nonatomic,assign)NSTimeInterval localCacheExpiredtime;

/**
 *从内存中取图片缓存，如果没找到，且localEnabled为yes，则取本地缓存中图片
 */
- (UIImage *)ImageFromCacheForImageURL:(NSString *)url fromLocal:(BOOL)localEnabled;

/**
 *将图片存入缓存
 */
- (UIImage *)ImageToCacheWithData:(NSData *)data forImageURL:(NSString *)url toLocal:(BOOL)localEnabled;


/**
 *清理缓存
 */
- (BOOL)clearCache;







@end
