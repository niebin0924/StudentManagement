//
//  UIImageView+WebImage.h
//  JYWebImage
//
//  Created by JourneyYoung on 16/7/28.
//  Copyright © 2016年 JourneyYoung. All rights reserved.
//


//线程优先级
typedef enum {
    JYWebImageQueuePriorityLow = 0,
    JYWebImageQueuePriorityNormal,
    JYWebImageQueuePriorityHigh,
} JYWebImageQueuePriority;

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

/**
 * 主要业务API，用于统一处理图片加载
 */
- (void)JYloadWebImage:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage;


@end
