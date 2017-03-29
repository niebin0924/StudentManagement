//
//  NBPhotoPickerGroup.h
//  StudentManagement
//
//  Created by Kitty on 17/3/28.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NBPhotoPickerGroup : NSObject

/**
 *  组名
 */
@property (nonatomic , copy  ) NSString *groupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy  ) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;

@end
