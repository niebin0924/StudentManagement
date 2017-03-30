//
//  UIImageView+WebImage.m
//  JYWebImage
//
//  Created by JourneyYoung on 16/7/28.
//  Copyright © 2016年 JourneyYoung. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "ImageCache.h"

//超时时间
const NSTimeInterval REQUEST_TIME_OUT_INTERVAL = 30.f;

@implementation UIImageView (WebImage)

-(void)JYloadWebImage:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
    [self setImageUrl:imageURL];
}

-(void)setImageUrl:(NSString *)imageUrl
{
    if(imageUrl.length>0)
    {
        /*
         * 1.创建缓存池
         * 2.去缓存池中取图片
         * 3.如果没有图片，则网络加载取图片
         */
        UIImage *cacheImage = [[ImageCache shareInstance] ImageFromCacheForImageURL:imageUrl fromLocal:YES];
        if(cacheImage)
        {
            self.image = cacheImage;
            return;
        }
        else
        {
            [self asyncLoadImageWithUrl:imageUrl];
        }
    }
}

-(void)asyncLoadImageWithUrl:(NSString *)imageUrl
{
    __block BOOL isSuccess;
    if(imageUrl)
    {
        dispatch_block_t loadImageBlock = ^(void) {
            
            NSLog(@"async load image start url");
            
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSURLSessionDownloadTask *task = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               
                if(error == nil)
                {
                    UIImage *image = [[ImageCache shareInstance] ImageToCacheWithData:[NSData dataWithContentsOfURL:location] forImageURL:imageUrl toLocal:YES];
                    isSuccess = YES;
                    //回到主线程，设置图片
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(isSuccess == YES)
                        {
                            
                            [self setImageWithAnimation:image];
                            NSLog(@"下载图片成功");
                        }
                        else
                        {
                            NSLog(@"未能成功加载图片");
                        }
                    });
                    
                }
                else
                {
                    isSuccess = NO;
                }
            }];
            
            
            [task resume];
            
        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), loadImageBlock);
    }
}


- (void)setImageWithAnimation:(UIImage *)img
{
    self.image = img;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    [self.layer removeAnimationForKey:@"kFadeAnimation"];
    [self.layer addAnimation:animation forKey:@"kFadeAnimation"];
}


@end
