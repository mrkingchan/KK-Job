//
//  MineFooterView.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineFooterView : UICollectionReusableView

@property (nonatomic,copy) void(^mineFooterClickCallBack)(NSInteger index);

@property (nonatomic,copy) NSArray * dataArr;

@end
