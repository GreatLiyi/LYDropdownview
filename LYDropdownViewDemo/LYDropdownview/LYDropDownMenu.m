//
//  LYDropDownMenu.m
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import "LYDropDownMenu.h"
#import <Masonry.h>
#import "LYDropDownMenuTitleButton.h"
#import "LYDropDownMenuUICalc.h"
#import "LYDropDownMenuCell.h"
typedef void(^LYDropDownMenuAnimateCompleteHandler)(void);

@implementation LYIndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)col row:(NSInteger)row {
    LYIndexPath *indexPath = [[self alloc] initWithColumn:col row:row];
    return indexPath;
}
@end

@interface LYDropDownMenu ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) NSInteger currentSelectedMenuIndex;
@property (nonatomic, assign) NSInteger numOfMenu;

@property (nonatomic, strong) UIView *coverLayerView;





//  dataSource
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) LYDropDownMenuTitleButton *selectedButton;
@property (nonatomic, weak) LYDropDownMenuCell *defaultSelectedCell;

@end
static NSString * const collectionCellID = @"LYDropDownMenuCollectionViewCell";
@implementation LYDropDownMenu
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentSelectedMenuIndex = -1;
        _show = NO;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = dropDownMenuCollectionViewUIValue()->SECTIONINSETS;
        flowLayout.itemSize = dropDownMenuCollectionViewUIValue()->ITEMSIZE;
        flowLayout.minimumLineSpacing = dropDownMenuCollectionViewUIValue()->LINESPACING;
        flowLayout.minimumInteritemSpacing = dropDownMenuCollectionViewUIValue()->INTERITEMSPACING;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.collectionViewLayout = flowLayout;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[LYDropDownMenuCell class] forCellWithReuseIdentifier:collectionCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizesSubviews = NO;
        self.autoresizesSubviews = NO;
        
        //        _backgroundView = [[UIView alloc] init];
        _backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _backgroundView.opaque = NO;
        [_backgroundView addTarget:self action:@selector(backgroundViewDidTap:) forControlEvents:UIControlEventTouchUpInside];
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
        //        [_backgroundView addGestureRecognizer:tapGesture];
        _window = [self keyWindow];
    }
    return self;
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, deviceWidth(), frame.size.height);
    [super setFrame:frame];
}

- (void)setDataSource:(id<LYDropDownMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    NSAssert([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)], @"does not respond 'numberOfColumnsInMenu:' method");
    _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    
    WS(weakSelf);
    CGFloat width = deviceWidth() / _numOfMenu;
    _titleButtons = [NSMutableArray arrayWithCapacity:_numOfMenu];
    LYDropDownMenuTitleButton *lastTitleButton = nil;
    LYDropDownMenuTitleButton *thirdButton = nil;
    for (NSInteger index = 0; index < _numOfMenu; index++) {
        
        NSString *titleString = [_dataSource menu:self titleForRowAtIndexPath:[LYIndexPath indexPathWithColumn:index row:0]];
        LYDropDownMenuTitleButton *titleButton = [[LYDropDownMenuTitleButton alloc] initWithMainTitle:[_dataSource menu:self titleForColumn:index] subTitle:titleString];
        [self addSubview:titleButton];
        [_titleButtons addObject:titleButton];
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(width);
            make.left.equalTo(lastTitleButton ? lastTitleButton.mas_right : weakSelf);
        }];
        
        
        lastTitleButton = titleButton;
        if (index != _numOfMenu - 1) {
            UIView *rightSeperator = [[UIView alloc] init];
            rightSeperator.backgroundColor = kDropdownMenuSeperatorColor;
            [titleButton addSubview:rightSeperator];
            [rightSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(titleButton);
                make.width.mas_equalTo(dropDownMenuTitleButtonUIValue()->RIGHTSEPERATOR_WIDTH);
            }];
        }
        titleButton.index = index;
        [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - animation method
- (void)animationWithTitleButton:(LYDropDownMenuTitleButton *)button BackgroundView:(UIView *)backgroundView
                  collectionView:(UICollectionView *)collectionView
                            show:(BOOL)isShow
                        complete:(LYDropDownMenuAnimateCompleteHandler)complete
{
    WS(weakSelf);
    if (self.selectedButton == button) {
        button.selected = isShow;
        self.coverLayerView.hidden = NO;
    } else {
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
    }
    [self animationWithBackgroundView:backgroundView show:isShow complete:^{
        [weakSelf animationWithCollectionView:collectionView show:isShow complete:nil];
    }];
    if (complete) {
        complete();
    }
}


- (void)animationWithBackgroundView:(UIView *)backgroundView
                     collectionView:(UICollectionView *)collectionView
                               show:(BOOL)isShow
                           complete:(LYDropDownMenuAnimateCompleteHandler)complete
{
    WS(weakSelf);
    [self animationWithBackgroundView:backgroundView show:isShow complete:^{
        [weakSelf animationWithCollectionView:collectionView show:isShow complete:nil];
    }];
    if (complete) {
        complete();
    }
}

#pragma mark 添加backgroundview
- (void)animationWithBackgroundView:(UIView *)backgroundView
                               show:(BOOL)isShow
                           complete:(LYDropDownMenuAnimateCompleteHandler)complete
{
    WS(weakSelf);
    if (isShow) {
        if (1 == clickCount) {
            [self.window addSubview:backgroundView];
            [backgroundView addSubview:self.collectionView];
            [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                CGRect rect = [weakSelf convertRect:weakSelf.bounds toView:weakSelf.window];
                make.top.mas_equalTo(CGRectGetMaxY(rect));
                make.left.right.bottom.equalTo(weakSelf.window);
            }];
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(weakSelf.backgroundView);
                make.height.mas_equalTo(0.f);
            }];
            [backgroundView layoutIfNeeded];
        }
        [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            clickCount = 0;
        }];
    }
    if (complete) {
        complete();
    }
}

- (void)animationWithCollectionView:(UICollectionView *)collectionView
                               show:(BOOL)isShow
                           complete:(LYDropDownMenuAnimateCompleteHandler)complete
{
    WS(weakSelf);
    if (isShow) {
        CGFloat collectionViewHeight = 0.f;
        if (collectionView) {
            NSInteger rowCount = (NSInteger)ceilf((CGFloat)[collectionView numberOfItemsInSection:0] / dropDownMenuCollectionViewUIValue()->VIEW_COLUMNCOUNT);
            collectionViewHeight = dropDownMenuCollectionViewUIValue()->VIEW_TOP_BOTTOM_MARGIN * 2 + dropDownMenuCollectionViewUIValue()->CELL_HEIGHT * rowCount + dropDownMenuCollectionViewUIValue()->LINESPACING * (rowCount - 1);
            CGFloat maxHeight = deviceHeight() - CGRectGetMaxY(self.frame);
            collectionViewHeight = collectionViewHeight > maxHeight ? maxHeight : collectionViewHeight;
            
            if (1 == clickCount) {
                self.coverLayerView.hidden = NO;
                [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
                    [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(collectionViewHeight);
                    }];
                    [collectionView.superview layoutIfNeeded];
                }completion:^(BOOL finished) {
                    weakSelf.coverLayerView.hidden = YES;
                    NSLog(@"%d", self.collectionView.isUserInteractionEnabled);
                }];
            } else {
                [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
                    [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(collectionViewHeight);
                    }];
                    [collectionView.superview layoutIfNeeded];
                }];
                
            }
        }
        
        
    } else {
        if (collectionView) {
            
            [UIView animateWithDuration:dropDownMenuUIValue()->ANIMATION_DURATION animations:^{
                [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                [collectionView.superview layoutIfNeeded];
            } completion:^(BOOL finished) {
                [collectionView removeFromSuperview];
                weakSelf.coverLayerView.hidden = YES;
                clickCount = 0;
            }];
        }
    }
    if (complete) {
        complete();
    }
}



- (CGRect)screenBounds
{
    return [self keyWindow].bounds;
}

- (UIWindow *)keyWindow
{
    return [[[UIApplication sharedApplication] windows] lastObject];
}

#pragma mark -- lazyLoad
- (UIView *)coverLayerView
{
    if (_coverLayerView == nil) {
        _coverLayerView = [[UIView alloc] init];
        _coverLayerView.frame = [self screenBounds];
        _coverLayerView.backgroundColor = [UIColor clearColor];
        _coverLayerView.hidden = YES;
        [self.window addSubview:_coverLayerView];
    }
    return _coverLayerView;
}



#pragma mark - action method
static NSInteger clickCount;
- (void)titleButtonDidClick:(LYDropDownMenuTitleButton *)titleButton
{
    clickCount++;
    WS(weakSelf);
    if (titleButton.index == self.currentSelectedMenuIndex && self.isShow) {
        [self animationWithTitleButton:titleButton BackgroundView:self.backgroundView collectionView:self.collectionView show:NO complete:^{
            weakSelf.currentSelectedMenuIndex = titleButton.index;
            weakSelf.show = NO;
        }];
    } else {
        self.currentSelectedMenuIndex = titleButton.index;
        [self.collectionView reloadData];
        [self animationWithTitleButton:titleButton BackgroundView:self.backgroundView collectionView:self.collectionView show:YES complete:^{
            weakSelf.show = YES;
        }];
    }
}



- (void)backgroundViewDidTap:(UIButton *)tapGesture
{
    WS(weakSelf);
    LYDropDownMenuTitleButton *titleButton = self.titleButtons[self.currentSelectedMenuIndex];
    [self animationWithTitleButton:titleButton BackgroundView:self.backgroundView collectionView:self.collectionView show:NO complete:^{
        weakSelf.show = NO;
    }];
}

#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSAssert([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumns:)], @"does not respond the 'menu:numberOfRowsInColumns:' method");
    return [self.dataSource menu:self numberOfRowsInColumns:self.currentSelectedMenuIndex];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYDropDownMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    NSAssert([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)], @"does not respond the 'menu:titleForRowAtIndexPath:' method");
    cell.contentString = [self.dataSource menu:self titleForRowAtIndexPath:[LYIndexPath indexPathWithColumn:self.currentSelectedMenuIndex row:indexPath.row]];
    if ([cell.contentString isEqualToString:[self.titleButtons[self.currentSelectedMenuIndex] subTitle]]) {
        cell.selected = YES;
        self.defaultSelectedCell = cell;
    }
    return cell;
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)], @"does not set delegate or respond the 'menu:titleForRowAtIndexPath:' method");
    [self.delegate menu:self didSelectRowAtIndexPath:[LYIndexPath indexPathWithColumn:self.currentSelectedMenuIndex row:indexPath.row]];
    [self configMenuSubTitleWithSelectRow:indexPath.row];
    
}

- (void)configMenuSubTitleWithSelectRow:(NSInteger)row
{
    WS(weakSelf);
    LYDropDownMenuTitleButton *button = _titleButtons[self.currentSelectedMenuIndex];
    NSString *currentSelectedTitle = [self.dataSource menu:self titleForRowAtIndexPath:[LYIndexPath indexPathWithColumn:self.currentSelectedMenuIndex row:row]];
    NSString *maintitle = [self.dataSource menu:self titleForColumn:self.currentSelectedMenuIndex];
    
    
    
    //
    button.subTitle = currentSelectedTitle;
    if (![currentSelectedTitle isEqualToString:@"全部"]) {
        //        button.subTitle = currentSelectedTitle;
        button.mainTitleLabel.text = currentSelectedTitle;
    }else{
        //        button.mainTitle = maintitle;
        button.mainTitleLabel.text = maintitle;
    }
    if (![self.defaultSelectedCell.contentString isEqualToString:currentSelectedTitle]) {
        self.defaultSelectedCell.selected = NO;
    }
    [self animationWithTitleButton:button BackgroundView:self.backgroundView collectionView:self.collectionView show:NO complete:^{
        weakSelf.show = NO;
    }];
}

@end
