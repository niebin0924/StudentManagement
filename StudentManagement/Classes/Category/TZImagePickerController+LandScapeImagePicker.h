//
//  TZImagePickerController+LandScapeImagePicker.h
//  StudentManagement
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>

@interface TZImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
