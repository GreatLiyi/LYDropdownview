//
//  LYDropDownMenu.h
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYIndexPath : NSObject
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)col row:(NSInteger)row;

@end

@class LYDropDownMenu;

@protocol LYDropDownMenuDataSource <NSObject>
@required
- (NSInteger)numberOfColumnsInMenu:(LYDropDownMenu *)menu;
- (NSInteger)menu:(LYDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column;
- (NSString *)menu:(LYDropDownMenu *)menu titleForColumn:(NSInteger)column;
@optional
- (NSString *)menu:(LYDropDownMenu *)menu titleForRowAtIndexPath:( LYIndexPath*)indexPath;
@end

@protocol LYDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(LYDropDownMenu *)menu didSelectRowAtIndexPath:(LYIndexPath *)indexPath;

@end

@interface LYDropDownMenu : UIView
@property (nonatomic, weak) id <LYDropDownMenuDataSource>dataSource;
@property (nonatomic, weak) id <LYDropDownMenuDelegate>delegate;

@property (nonatomic, weak) UIWindow *window;

@property (nonatomic, strong) UIButton *backgroundView;
- (void)backgroundViewDidTap:(UIButton *)tapGesture;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign, getter=isShow) BOOL show;
@end
