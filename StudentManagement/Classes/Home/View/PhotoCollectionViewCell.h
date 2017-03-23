//
//  PhotoCollectionViewCell.h
//  StudentManagement
//
//  Created by Kitty on 17/2/24.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
