//
//  LYDropDownMenuTitleButton.m
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import "LYDropDownMenuTitleButton.h"
#import <Masonry.h>
#import "LYDropDownMenuUICalc.h"
#import "NSString+size.h"


@implementation LYDropDownMenuTitleButton

- (instancetype)initWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle
{
    if (self = [super init]) {
        _mainTitle = mainTitle;
        _subTitle = subTitle;
        self.backgroundColor = [UIColor whiteColor];
        self.adjustsImageWhenHighlighted = YES;
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithMainTitle:title subTitle:nil];
}

- (void)viewConfig
{
    WS(weakSelf);
    UIView *containerView = [[UIView alloc] init];
    containerView.userInteractionEnabled = NO;
    [self addSubview:containerView];
    
    _mainTitleLabel = [[UILabel alloc] init];
    _mainTitleLabel.text = _mainTitle;
    _mainTitleLabel.font = [UIFont systemFontOfSize:dropDownMenuTitleButtonUIValue()->MAINTITLELABEL_FONT];
    _mainTitleLabel.adjustsFontSizeToFitWidth = YES;
    _mainTitleLabel.textColor = kDropdownMenuTitleColor;
    [containerView addSubview:_mainTitleLabel];
    
    _arrowView = [[UIView alloc] init];
    [self addSubview:_arrowView];
    
    CGSize mainTitleSize = [_mainTitle zl_stringSizeWithFont:
                            [UIFont systemFontOfSize:dropDownMenuTitleButtonUIValue()->MAINTITLELABEL_FONT]];
    CGSize subTitleSize = [_subTitle zl_stringSizeWithFont:
                           
                           [UIFont systemFontOfSize:dropDownMenuTitleButtonUIValue()->SUBTITLELABEL_FONT]];
    if (_subTitle == nil) {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [_mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(containerView);
            make.size.mas_equalTo(mainTitleSize);
        }];
    } else {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:dropDownMenuTitleButtonUIValue()->SUBTITLELABEL_FONT];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = _subTitle;
        _subTitleLabel.textColor = kDropdownMenuTitleColor;
        _subTitleLabel.hidden = YES;
        [containerView addSubview:_subTitleLabel];
        
        CGFloat containerViewHeight = mainTitleSize.height + subTitleSize.height + dropDownMenuTitleButtonUIValue()->SUBTITLELABEL_TOPMARGIN;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(weakSelf);
            make.height.mas_equalTo(containerViewHeight);
        }];
        
        //        [_mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.centerX.equalTo(containerView);
        //            make.width.mas_equalTo(mainTitleSize.width);
        //            make.height.mas_equalTo(mainTitleSize.height);
        //        }];
        [_mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(containerView);
            //            make.size.mas_equalTo(mainTitleSize);
        }];
        [_mainTitleLabel sizeToFit];
        
    }
    
    _arrowView = [[UIView alloc] init];
    [containerView addSubview:_arrowView];
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mainTitleLabel.mas_right).offset(dropDownMenuTitleButtonUIValue()->ARROWVIEW_LEFTMARGIN);
        make.centerY.equalTo(weakSelf.mainTitleLabel);
        make.width.mas_equalTo(dropDownMenuTitleButtonUIValue()->ARROWVIEW_WIDTH);
        make.height.mas_equalTo(dropDownMenuTitleButtonUIValue()->ARROWVIEW_HEIGHT);
    }];
    _shapeLayer = [self creatArrowShapeLayer];
    [_arrowView.layer addSublayer:_shapeLayer];
    
    UIView *bottomSeperator = [[UIView alloc] init];
    bottomSeperator.backgroundColor = kDropdownMenuSeperatorColor;
    [self addSubview:bottomSeperator];
    [bottomSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(dropDownMenuTitleButtonUIValue()->BOTTOMSEPERATOR_HEIGHT);
    }];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = navColor;
    [self addSubview:_bottomLineView];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(dropDownMenuTitleButtonUIValue()->BOTTOMLINE_HEIGHT);
    }];
    _bottomLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _bottomLineView.hidden = !selected;
    WS(weakSelf);
    _mainTitleLabel.textColor = selected ? navColor: kDropdownMenuTitleColor;
    _subTitleLabel.textColor = selected ? navColor : kDropdownMenuTitleColor;
    if (selected) {
        [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
            weakSelf.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
            weakSelf.arrowView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (CAShapeLayer *)creatArrowShapeLayer
{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(dropDownMenuTitleButtonUIValue()->ARROWVIEW_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(dropDownMenuTitleButtonUIValue()->ARROWVIEW_WIDTH * 0.5, dropDownMenuTitleButtonUIValue()->ARROWVIEW_HEIGHT)];
    [path closePath];
    
    shapeLayer.path = path.CGPath;
    //    shapeLayer.fillColor = [kDropdownMenuIndicatorColor CGColor];
    shapeLayer.fillColor = [navColor CGColor];
    return shapeLayer;
}

- (void)setArrowColor:(UIColor *)arrowColor
{
    _arrowColor = arrowColor;
    _shapeLayer.fillColor = _arrowColor.CGColor;
    //    _shapeLayer.fillColor = navColor.CGColor;
}

- (void)setMainTitleColor:(UIColor *)mainTitleColor
{
    _mainTitleColor = mainTitleColor;
    //    _mainTitleLabel.textColor = _mainTitleColor;
    _mainTitleLabel.textColor = navColor;
}

- (void)setSubTitleColor:(UIColor *)subTitleColor
{
    _subTitleColor = subTitleColor;
    _subTitleLabel.textColor = navColor;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = [subTitle copy];
    
}

@end
