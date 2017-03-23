//
//  SomeSubjectViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SomeSubjectViewController : UIViewController

@property (nonatomic,assign) FolderType folderType;
@property (nonatomic,strong) NSString *subjectId;
@property (nonatomic,strong) NSString *subjectName;

@end
