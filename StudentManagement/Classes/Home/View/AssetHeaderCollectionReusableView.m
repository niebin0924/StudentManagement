//
//  AssetHeaderCollectionReusableView.m
//  StudentManagement
//
//  Created by Kitty on 17/3/28.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "AssetHeaderCollectionReusableView.h"

@interface AssetHeaderCollectionReusableView ()

@property (weak, nonatomic) UILabel *footerLabel;

@end

@implementation AssetHeaderCollectionReusableView

- (UILabel *)footerLabel {
    if (!_footerLabel) {
        UILabel *footerLabel = [[UILabel alloc] init];
        footerLabel.frame = self.bounds;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:footerLabel];
        self.footerLabel = footerLabel;
    }
    return _footerLabel;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    if (count > 0) {
        self.footerLabel.text = [NSString stringWithFormat:@"有 %ld 张图片", (long)count];
    }
}

@end
