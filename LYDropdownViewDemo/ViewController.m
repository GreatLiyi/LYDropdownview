//
//  ViewController.m
//  LYDropdownViewDemo
//
//  Created by liyi on 2017/6/21.
//  Copyright © 2017年 liyi. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "LYDropDownMenuUICalc.h"
#import "LYDropDownMenuCell.h"
#import "LYDropDownMenu.h"
#import "NSString+size.h"

@interface ViewController () <LYDropDownMenuDelegate, LYDropDownMenuDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTitleArray = @[@"纹绣", @"美甲", @"美发", @"美妆",@"纹身",@"美睫"];
    _subTitleArray = @[
                       @[@"All", @"Arts", @"Memoirs", @"Business", @"Calendars", @"Education", @"Comics", @"Computers",  @"History"],
                       @[@"All", @"Animation", @"Drama", @"Comedy"],
                       @[@"All", @"Furniture", @"Bedding", @"Bath", @"Artwork"],
                       @[@"All", @"Blues", @"Christian", @"Country", @"Jazz", @"Pop", @"Folk", @"Gospel"],
                       @[@"All", @"Blues",  @"Country", @"Jazz", @"Pop", @"Folk", @"Gospel"]
                       ,@[@"All", @"Blues",  @"Country", @"Jazz", @"Pop", @"Folk", @"Gospel"]
                       ];
    
    LYDropDownMenu *menu = [[LYDropDownMenu alloc] init];
    menu.bounds = CGRectMake(0, 0, deviceWidth(), 50.f);
    menu.delegate = self;
    menu.dataSource = self;
    self.tableView.tableHeaderView = menu;
    
    
    //    UIView *topView = [[UIView alloc] init];
    //    topView.backgroundColor = [UIColor cyanColor];
    //    [self.view addSubview:topView];
    //    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.equalTo(weakSelf.view);
    //        make.height.mas_equalTo(100.f);
    //    }];
    //    ZLDropDownMenu *menu = [[ZLDropDownMenu alloc] init];
    //    [self.view addSubview:menu];
    //    menu.delegate = self;
    //    menu.dataSource = self;
    //    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(topView.mas_bottom);
    //        make.left.right.equalTo(weakSelf.view);
    //        make.height.mas_equalTo(50);
    //    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"1234";
    return cell;
}

#pragma mark - ZLDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(LYDropDownMenu *)menu
{
    return self.mainTitleArray.count;
}

- (NSInteger)menu:(LYDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column
{
    return [self.subTitleArray[column] count];
}

- (NSString *)menu:(LYDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    return self.mainTitleArray[column];
}

- (NSString *)menu:(LYDropDownMenu *)menu titleForRowAtIndexPath:(LYIndexPath *)indexPath
{
    NSArray *array = self.subTitleArray[indexPath.column];
    return array[indexPath.row];
}
#pragma mark - ZLDropDownMenuDelegate
- (void)menu:(LYDropDownMenu *)menu didSelectRowAtIndexPath:(LYIndexPath *)indexPath
{
    NSArray *array = self.subTitleArray[indexPath.column];
    NSLog(@"%@", array[indexPath.row]);
}

@end
