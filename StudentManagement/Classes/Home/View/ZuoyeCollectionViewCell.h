//
//  ZuoyeCollectionViewCell.h
//  StudentManagement
//
//  Created by Kitty on 17/3/5.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZuoyeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
