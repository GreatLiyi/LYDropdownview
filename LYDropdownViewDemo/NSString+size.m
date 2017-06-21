//
//  NSString+size.m
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import "NSString+size.h"
#import <Foundation/Foundation.h>
@implementation NSString (size)

- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}

- (CGSize)zl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self zl_stringSizeWithFont:font maxWidth:maxWidth maxHeight:MAXFLOAT];
}

- (CGSize)zl_stringSizeWithFont:(UIFont *)font
{
    return [self zl_stringSizeWithFont:font maxWidth:MAXFLOAT maxHeight:MAXFLOAT];
}


@end
