//
//  NBPhotoPickerDatas.h
//  StudentManagement
//
//  Created by Kitty on 17/3/28.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBPhotoPickerGroup.h"

// 回调
typedef void(^groupCallBackBlock)(id obj);

@interface NBPhotoPickerDatas : NSObject

@property (nonatomic,strong) ALAssetsLibrary *library;

/**
 *  获取所有组
 */
+ (instancetype) defaultPicker;

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithPhotos : (groupCallBackBlock ) callBack;

/**
 * 获取所有组对应的Videos
 */
- (void) getAllGroupWithVideos : (groupCallBackBlock ) callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void) getGroupPhotosWithGroup : (NBPhotoPickerGroup *) pickerGroup finished : (groupCallBackBlock ) callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(groupCallBackBlock ) callBack;


@end
