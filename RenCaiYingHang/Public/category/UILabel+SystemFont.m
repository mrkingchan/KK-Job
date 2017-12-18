//
//  UILabel+SystemFont.m
//  RenCaiYingHang
//
//  Created by Macx on 2017/12/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UILabel+SystemFont.h"

#import <objc/runtime.h>

@implementation UILabel (SystemFont)

+ (void)load{
    //利用running time运行池的方法在程序启动的时候把两个方法替换 适用Xib建立的label
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);  //交换方法
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = systemOfFont(fontSize);
    }
    return self;
}

@end
