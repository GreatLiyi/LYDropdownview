//
//  NSString+size.h
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (size)

- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)zl_stringSizeWithFont:(UIFont *)font;


@end
