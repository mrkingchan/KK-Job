//
//  NecessarySexCell.h
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NecessarySexCell : UITableViewCell

@property (nonatomic,copy) void(^NecessarySexSelectCall) (NSInteger index);

@end
