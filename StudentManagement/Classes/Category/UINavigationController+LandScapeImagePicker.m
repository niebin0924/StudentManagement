//
//  UINavigationController+LandScapeImagePicker.m
//  StudentManagement
//
//  Created by Kitty on 17/3/31.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "UINavigationController+LandScapeImagePicker.h"

@implementation UINavigationController (LandScapeImagePicker)

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


@end
