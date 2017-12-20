//
//  RYAreaPickView.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectProvinceCityAreaCallBack)(NSString * province, NSString * city,NSInteger cId);//NSString * area,NSInteger aId

@interface RYAreaPickView : UIView

//数据字典
@property (nonatomic, strong)NSDictionary *areaDic;
//省级数组
@property (nonatomic, strong)NSArray *provinceArr;
//城市数组
@property (nonatomic, strong)NSMutableArray *cityArr;
//区、县数组
//@property (nonatomic, strong)NSMutableArray *districtArr;

//省份选择Button
@property (nonatomic, strong)UIButton *provinceBtn;
//城市选择Button
@property (nonatomic, strong)UIButton *cityBtn;
//区、县选择Button
//@property (nonatomic, strong)UIButton *districtBtn;
//滑动线条
@property (nonatomic, strong)UIView *selectLine;

@property (nonatomic, copy) selectProvinceCityAreaCallBack selectProvinceCityAreaCall;

/** */
- (void) show;

@end
