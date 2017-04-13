//
//  CaptureViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/4/12.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completion)(UIImage *);

@interface CaptureViewController : UIViewController

@property (nonatomic,copy) void(^completion)(UIImage *editImage);
@property (nonatomic,strong) UIImage *image;

@end
