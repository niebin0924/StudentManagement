//
//  ImportFolderViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/3/3.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1.生命block属性
typedef void(^ValueBlock) (NSString *);

@interface ImportFolderViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *photoArr;
@property (nonatomic,copy) ValueBlock valueBlock;

@end
