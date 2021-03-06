//
//  CustomeAlertViewWithCollection.h
//  弹框列表
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomeAlertViewWithCollection;

@protocol CustomeAlertViewDataSource <NSObject>
//ZJAlertListView有多少行
- (NSInteger)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView numberOfItemsInSection:(NSInteger)section;
//ZJAlertListView每个cell的样式
- (UICollectionViewCell *)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

//代理方法
@protocol CustomeAlertViewDelegate <NSObject>
//ZJAlertListView cell的选中
- (void)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//ZJAlertListView cell为被选中
- (void)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CustomeAlertViewWithCollectionDelegate <NSObject>

- (void)CustomeAlertViewWithCollection:(NSIndexPath *)indexpath;

@end

typedef void(^AlertResultIndexPath)(NSIndexPath *indexpath);

@interface CustomeAlertViewWithCollection : UIView

@property(nonatomic,copy) AlertResultIndexPath resultIndexpath;

@property (nonatomic, weak) id <CustomeAlertViewDataSource> datasource;

@property (nonatomic, weak) id <CustomeAlertViewDelegate> delegate;

@property (nonatomic, weak) id <CustomeAlertViewWithCollectionDelegate> indexDelegate;

@property(nonatomic,strong) NSArray *dataArray;

- (instancetype)initWithTitle:(NSString *)title collectionCellName:(NSString *)cellName sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)show;

//列表cell的重用
- (id)dequeueReusableAlertCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (UICollectionViewCell *)alertCellForItemAtIndexPath:(NSIndexPath *)indexPath;

//选中的列表元素
//- (NSIndexPath *)indexPathForSelectedItem;

@end
