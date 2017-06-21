//
//  LYDropDownMenuTitleButton.h
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDropDownMenuTitleButton : UIButton
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *mainTitleColor;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithMainTitle:(NSString *)mainTitle
                         subTitle:(NSString *)subTitle;

- (instancetype)initWithTitle:(NSString *)title;
@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *arrowView;

@property (nonatomic, strong) UIView *bottomLineView;
@end
