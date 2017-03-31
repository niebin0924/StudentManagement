//
//  Mark.h
//  StudentManagement
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mark : NSObject <NSCoding>

@property (nonatomic,assign) float x;
@property (nonatomic,assign) float y;
@property (nonatomic,copy) NSString *content;
// 存储多张图片的url
@property (nonatomic,copy) NSArray<NSString *> *content_img;
// 存储多张图片image
@property (nonatomic,copy) NSArray<UIImage *> *images;

- (NSDictionary *)TurnToDict;

@end
