//
//  PhotoAssetViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/3/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBPhotoPickerGroup;

@interface PhotoAssetViewController : UIViewController

@property (nonatomic, strong) NBPhotoPickerGroup *assetsGroup;
// 需要记录选中的值的数据
@property (nonatomic, strong) NSArray *selectPickerAssets;

@property (nonatomic, copy) void(^selectedAssetsBlock)(NSMutableArray *selectedAssets);

@end
