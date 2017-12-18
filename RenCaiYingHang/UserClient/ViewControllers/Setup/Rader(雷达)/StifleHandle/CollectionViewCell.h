//
//  CollectionViewCell.h
//  CollectionView
//
//  Created by Macx on 2017/12/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) void(^collectionViewCellCallBack)(NSInteger index);

@end
