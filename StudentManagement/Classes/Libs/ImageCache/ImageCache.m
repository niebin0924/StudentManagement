//
//  ImageCache.m
//  JYWebImage
//
//  Created by JourneyYoung on 16/7/28.
//  Copyright © 2016年 JourneyYoung. All rights reserved.
//

#import "ImageCache.h"
//默认参数

const NSString *const LOCAL_CAHCE_DIRECTORY_DEFAULT = @"JYWebImage";
const NSTimeInterval LOCAL_CACHE_EXPIRED_TIME_DEFAULT = 10;



@implementation ImageCache

//创建单例
+(ImageCache *)shareInstance
{
    static ImageCache *_imageCache = nil;
    static dispatch_once_t _oncePredicate;
    dispatch_once(&_oncePredicate, ^{
        _imageCache = [[ImageCache alloc]init];
    });
    return _imageCache;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self AllInit];
    }
    return self;
}

-(void)AllInit
{
    self.memoryCache = [[NSCache alloc] init];
    self.memoryCache.totalCostLimit = 10;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (0 < [cachesPath length]) {
        self.localCacheDirectory = [cachesPath stringByAppendingPathComponent:(NSString *)LOCAL_CAHCE_DIRECTORY_DEFAULT];
    }
    
    self.localCacheExpiredtime = LOCAL_CACHE_EXPIRED_TIME_DEFAULT;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanAllMemoryCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanExpiredLocalCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}





//清除所有内存中缓存
- (void)cleanAllMemoryCache
{
    [self.memoryCache removeAllObjects];
}

//方法来源SDWebImage
- (void)cleanExpiredLocalCache
{
    if (self.localCacheExpiredtime <= 0) {
        return;
    }
    
    __block UIBackgroundTaskIdentifier bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // End the background task when expiration.
        if (UIBackgroundTaskInvalid != bgTaskIdentifier) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskIdentifier];
            bgTaskIdentifier = UIBackgroundTaskInvalid;
            NSLog(@"end the background task when expiration");
        }
    }];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *localCacheDirURL = [NSURL fileURLWithPath:_localCacheDirectory isDirectory:YES];
    NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtURL:localCacheDirURL
                                     includingPropertiesForKeys:resourceKeys
                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                   errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                       return YES;
                                                   }];
    NSError *error = nil;
    for (NSURL *fileURL in fileEnumerator) {
        @autoreleasepool {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            if ([resourceValues[NSURLIsDirectoryKey] boolValue])
            {
                continue;
            }
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if (self.localCacheExpiredtime <= -[modificationDate timeIntervalSinceNow])
            {
                error = nil;
                [fm removeItemAtURL:fileURL error:&error];
                NSLog(@"remove file for clean expired local cache %f error:%@", [modificationDate timeIntervalSinceNow], error);
            }
        }
    }
    
    if (UIBackgroundTaskInvalid != bgTaskIdentifier) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskIdentifier];
        bgTaskIdentifier = UIBackgroundTaskInvalid;
        NSLog(@"end the background task with clean expired local cache");
    }
}


-(void)setLocalCacheDirectory:(NSString *)localCacheDirectory
{
    _localCacheDirectory = localCacheDirectory;
    if(localCacheDirectory.length>0)
    {
        BOOL isDirectory = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:_localCacheDirectory isDirectory:&isDirectory] || !isDirectory) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:_localCacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
}

-(void)setLocalCacheExpiredtime:(NSTimeInterval)localCacheExpiredtime
{
    _localCacheExpiredtime = localCacheExpiredtime;
    if(0>=localCacheExpiredtime)
    {
        _localCacheExpiredtime = 0;
    }
}


-(UIImage *)ImageFromCacheForImageURL:(NSString *)url fromLocal:(BOOL)localEnabled
{
    UIImage *image = [self cachedImageForKey:url];
    NSLog(@"取图片时的imageURL：%@",url);
    if(!image && localEnabled && _localCacheDirectory)
    {
        NSString *localCachePath = [_localCacheDirectory stringByAppendingPathComponent:[url md5String]];
//        NSLog(@"%@",[url md5String]);
//        NSLog(@"%@",localCachePath);
        NSData *imagedata = [NSData dataWithContentsOfFile:localCachePath];
        image = [UIImage imageWithData:imagedata];
        if(image)
        {
           [self cacheImage:image forKey:url];
        }
        
    }
    return image;
}


-(UIImage *)ImageToCacheWithData:(NSData *)data forImageURL:(NSString *)url toLocal:(BOOL)localEnabled
{
    UIImage *image = [UIImage imageWithData:data];
    [self cacheImage:image forKey:url];
    NSLog(@"存图片时的imageURL：%@",url);
    if(localEnabled && _localCacheDirectory)
    {
        NSString *localCachePath = [_localCacheDirectory stringByAppendingPathComponent:[url md5String]];
        NSError *error = nil;
        [data writeToFile:localCachePath options:NSDataWritingFileProtectionComplete error:&error];
        NSLog(@"cache image local cache path:%@ error:%@", localCachePath, error);
    }
    return image;
    
}

//清除缓存
- (BOOL)clearCache
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *contents = [fm contentsOfDirectoryAtPath:_localCacheDirectory error:&error];
    @autoreleasepool {
        for (NSString *itemName in contents) {
            NSString *absolutePath = [_localCacheDirectory stringByAppendingPathComponent:itemName];
            error = nil;
            [fm removeItemAtPath:absolutePath error:&error];
            NSLog(@"清除缓存，error:%@", error);
        }
    }
    if (nil == error) {
        [self.memoryCache removeAllObjects];
        return YES;
    } else {
        return NO;
    }
}


//取缓存中图片
- (UIImage *)cachedImageForKey:(NSString *)key
{
    return [self.memoryCache objectForKey:key];
}


//缓存图片
- (void)cacheImage:(UIImage *)image forKey:(NSString *)key
{
    if (image && key) {
        [self.memoryCache setObject:image forKey:key];
    }
}

@end
