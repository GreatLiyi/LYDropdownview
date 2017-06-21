//
//  LYDropDownMenuCell.m
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import "LYDropDownMenuCell.h"
#import <Masonry.h>
#import "LYDropDownMenuUICalc.h"

@interface LYDropDownMenuCell ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation LYDropDownMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self viewConfig];
    }
    return self;
}


- (void)viewConfig
{
    WS(weakSelf);
    _label = [[UILabel alloc] init];
    _label.layer.cornerRadius = dropDownMenuCollectionViewUIValue()->CELL_LABEL_CORNERRADIUS;
    _label.layer.masksToBounds = YES;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:dropDownMenuCollectionViewUIValue()->CELL_LABEL_FONT];
    _label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

- (void)setContentString:(NSString *)contentString
{
    _contentString = [contentString copy];
    _label.text = _contentString;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _label.backgroundColor = selected ? navColor : [UIColor clearColor];
    _label.textColor = selected ? [UIColor whiteColor] : kDropdownMenuUnselectedCellTextColor;
}

@end
