//
//  UIButton+SystemFont.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UIButton+SystemFont.h"
#import <objc/runtime.h>

@implementation UIButton (SystemFont)

+ (void)load{
    
    //利用running time运行池的方法在程序启动的时候把两个方法替换 适用Xib建立的label
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);  //交换方法
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成2016跳过
//        if (IS_IPHONE_6P) {
//            if(self.tag != 2016) {
        CGFloat fontSize = self.titleLabel.font.pointSize;
        self.titleLabel.font = systemOfFont(fontSize);
//            }
//        }
    }
    return self;
}

@end
