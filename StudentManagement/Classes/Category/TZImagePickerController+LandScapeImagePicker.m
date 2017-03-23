//
//  TZImagePickerController+LandScapeImagePicker.m
//  StudentManagement
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "TZImagePickerController+LandScapeImagePicker.h"

@implementation TZImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
