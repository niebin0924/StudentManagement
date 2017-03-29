//
//  NBAblumTool.m
//  StudentManagement
//
//  Created by Kitty on 17/3/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "NBAblumTool.h"

@implementation NBAblumList



@end

@implementation NBAblumTool

static NBAblumTool *sharePhotoTool = nil;
+ (instancetype)sharePhotoTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [[self alloc] init];
    });
    return sharePhotoTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [super allocWithZone:zone];
    });
    return sharePhotoTool;
}

#pragma mark - 获取所有相册列表
- (NSArray<NBAblumList *> *)getPhotoAblumList
{
    NSMutableArray<NBAblumList *> *photoAblumList = [NSMutableArray array];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉慢动作、视频和最近删除
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] ||
              [collection.localizedTitle isEqualToString:@"Videos"] || [collection.localizedTitle isEqualToString:@"Slo-mo"])) {
            NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
            if (assets.count > 0) {
                NBAblumList *ablum = [[NBAblumList alloc] init];
                ablum.title = [self transformAblumTitle:collection.localizedTitle];
                ablum.count = assets.count;
                ablum.headImageAsset = assets.firstObject;
                ablum.assetCollection = collection;
                [photoAblumList addObject:ablum];
            }
        }
    }];
    
    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            NBAblumList *ablum = [[NBAblumList alloc] init];
            ablum.title = collection.localizedTitle;
            ablum.count = assets.count;
            ablum.headImageAsset = assets.firstObject;
            ablum.assetCollection = collection;
            [photoAblumList addObject:ablum];
        }
    }];
    
    return photoAblumList;
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    }
    return nil;
}

- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        
        [assets addObject:asset];
    }];
    
    return assets;
}

#pragma mark - 获取指定相册内的所有图片
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

#pragma mark - 获取asset对应的图片
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}


#pragma mark - ALAssetsLibrary
// 遍历照片库
- (NSArray<ALAssetsGroup*> *)enumerateAssetsGroup
{
    NSMutableArray<ALAssetsGroup *> *groups = [NSMutableArray array];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // 遍历相册
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) { // 遍历相册还未结束
            // 设置过滤器
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets) {
                
                
                
                [groups addObject:group];
            }
        } else { // 遍历结束（当group为空的时候就意味着结束）
            if (groups.count) {
                // 如果相册个数不为零，则可以在此处开始遍历相册了
                //[self enumerateAssets];
            } else {
                NSLog(@"没有相册列表");
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"遍历失败");
    }];
    NSLog(@"groups=%@",groups);
    return groups;
}

// 获取指定相册的所有照片
- (NSArray<ALAsset *> *)enumerateAssetsInAssetsGroup:(ALAssetsGroup *)group
{
    NSMutableArray<ALAsset *> *assets = [NSMutableArray new];
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) { // 遍历未结束
            [assets addObject:result];
        } else { // result 为nil，遍历结束
            
        }
    }];
    
    return assets;
}

- (NSArray<ALAsset *> *)enumerateAssetsToIndex:(NSInteger)toIndex
{
    NSArray<ALAssetsGroup *> *groups = [self enumerateAssetsGroup];
    NSMutableArray<ALAsset *> *assets = [NSMutableArray new];
    for (ALAssetsGroup * group in groups) {
        
        /*
         // 遍历所有的相片
         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
         if (result) { // 遍历未结束
         [assets addObject:result];
         } else { // result 为nil，遍历结束
         
         }
         }];
         */
        
        // 遍历指定的相片
//        NSInteger fromIndex = 0; // 重指定的index开始遍历
//        NSInteger toIndex =5; // 指定最后一张遍历的index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:toIndex] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (index > toIndex) { // 已经遍历到指定的最后一张照片
                *stop = YES; // 停止遍历
            } else {
                if (result) {
                    // 存储相片
                    [assets addObject:result];
                } else { // 遍历结束
                    // 展示图片
                    //[self showPhotoWith:result];
                }
            }
        }];
    }
    
    return assets;
}

- (void)showPhotoWith:(ALAsset *)asset
{
    // 获取ALAsset对应的ALAssetRepresentation
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    NSLog(@"图片URL:%@", representation.url); // 图片URL
    NSLog(@"图片尺寸:%@", NSStringFromCGSize(representation.dimensions)); // 图片尺寸
    NSLog(@"数据字节:%lld", representation.size); // 数据字节
    NSLog(@"统一类型标识符:%@", representation.UTI); // Uniform Type Identifier : 统一类型标识符（表示图片或视频的类型）
    NSLog(@"文件名:%@", representation.filename); // 在相册中的文件名
    NSLog(@"元数据:%@", representation.metadata); // 元数据（一些设备相关的信息，比如使用的相机）
    NSLog(@"缩放比例:%lf", representation.scale); // 缩放比例
    NSLog(@"方向:%ld", representation.orientation); // 方向
    
    /**
     fullScreenImage : 返回当前设备尺寸大小的图片，编辑后的图片
     fullResolutionImage ： 原图，没有编辑的图片
     */
    // 获取原图
    UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0 && [[UIDevice currentDevice].systemVersion doubleValue] <= 9.5) {
        [asset aspectRatioThumbnail]; // 等比例缩略图 iOS9
    }else {
        [asset thumbnail];
    }
}

- (void)getImage
{
    ALAssetsGroup *gg;
    NSArray<ALAssetsGroup *> *groups = [self enumerateAssetsGroup];
    for (ALAssetsGroup *group in groups) {
        NSString *name = [group valueForProperty:@"ALAssetsGroupPropertyName"];
        //查看相册存储的位置地址
        NSLog(@"ALAssetsGroupPropertyURL:%@",[group valueForProperty:ALAssetsGroupPropertyURL]);
        if ([name rangeOfString:@"相机"].location != NSNotFound) {
            gg = group;
        }
    }
    
    NSMutableArray<ALAsset *> *assets = [self enumerateAssetsInAssetsGroup:gg];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}


@end
