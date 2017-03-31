//
//  NBAblumTool.h
//  StudentManagement
//
//  Created by Kitty on 17/3/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

/*
 PHAsset:一个资源，比如一张图片/一段视频
 PHAssetCollection:一个相簿
 PHImageManager:图片管理者，是单例，发送请求才能从asset获取图片
 PHImageRequestOptions:图片请求选项
 
 
 AssetsLibrary:iPhone中的资源库
 AssetsGroup:一个相册
 ALAsset:一个资源，比如一张图片/一段视频
 ALAssetRepresentation:可以获取原图、全屏图。每个 ALAsset 都有至少有一个 ALAssetRepresentation 对象，可以通过 defaultRepresentation 获取
 
 //关闭监听共享照片流产生的频繁通知信息
 [ALAssetsLibrary disableSharedPhotoStreamsSupport];
 */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

//建一个内部类
@interface NBAblumList : NSObject
@property (nonatomic, copy) NSString *title; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property (nonatomic, strong) PHAsset *headImageAsset; //相册第一张图片缩略图
@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片
@end

@interface NBAblumTool : NSObject

+ (instancetype)sharePhotoTool;

/**
 * @brief 获取用户所有相册列表
 */
- (NSArray<NBAblumList *> *)getPhotoAblumList;


/**
 * @brief 获取相册内所有图片资源
 * @param ascending 是否按创建时间正序排列 YES,创建时间正（升）序排列; NO,创建时间倒（降）序排列
 */
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;


/**
 * @brief 获取指定相册内的所有图片
 */
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;


/**
 * @brief 获取每个Asset对应的图片
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

@end
