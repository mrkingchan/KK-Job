//
//  MineHeaderView.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderView : UICollectionReusableView

/** 图片点击事件 */
@property (nonatomic,copy) void(^mineHeaderClickCallBack)(NSInteger index);

/** 按钮点击事件 **/
@property (nonatomic,copy) void(^mineHeaderButtonCallBack)(NSInteger index);

/** 选择状态点击事件 */
@property (nonatomic,copy) void(^mineHeaderStatusCallBack)(void);

@property (nonatomic,copy) NSArray * dataArr;

@property (nonatomic,strong) NSDictionary * user;

@end
