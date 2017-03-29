//
//  NBPhotoAssets.h
//  StudentManagement
//
//  Created by Kitty on 17/3/28.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NBPhotoAssets : NSObject

@property (strong,nonatomic) ALAsset *asset;
@property (assign,nonatomic) BOOL isSel;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  压缩原图
 */
- (UIImage *)compressionImage;
/**
 *  原图
 */
- (UIImage *)originImage;
- (UIImage *)fullResolutionImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取相片的URL
 */
- (NSURL *)assetURL;

/**
 *  获取相片的文件名
 */
- (NSString *)fileName;

@end
