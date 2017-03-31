//
//  UINavigationController+LandScapeImagePicker.h
//  StudentManagement
//
//  Created by Kitty on 17/3/31.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LandScapeImagePicker)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
