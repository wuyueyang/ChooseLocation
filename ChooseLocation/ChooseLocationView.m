//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
//#define HYBarItemMargin 20  //地址标签栏之间的间距
#define HYTopViewHeight 40    //顶部视图的高度
#define HYTopTabbarHeight 30  //地址标签栏的高度

#define HYScreenW [UIScreen mainScreen].bounds.size.width

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) AddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSArray * dataSouce1;
@property (nonatomic,strong) NSArray * dataSouce2;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, HYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.top;
    topView.backgroundColor = [UIColor greenColor];
    
    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, HYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height;
    topTabbar.backgroundColor = [UIColor orangeColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor greenColor];
    
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - HYTopViewHeight - HYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    [self addTableView];
}

- (void)addTableView{

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

- (void)changeUnderLineFrame:(UIButton  *)btn{
   
        _underLine.left = btn.left;
        _underLine.width = btn.width;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        return self.dataSouce1.count;
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        return self.dataSouce2.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if([self.tableViews indexOfObject:tableView] == 0){
        cell.textLabel.text = self.dataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        cell.textLabel.text = self.dataSouce1[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        cell.textLabel.text = self.dataSouce2[indexPath.row];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addTopBarItem];
    [self addTableView];
    
    if([self.tableViews indexOfObject:tableView] == 0){
        [self scrollToNextItem:self.dataSouce[indexPath.row]];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        [self scrollToNextItem:self.dataSouce1[indexPath.row]];
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        [self scrollToNextItem:self.dataSouce2[indexPath.row]];
    }
}

- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
        CGSize  size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + HYScreenW, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}

- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    separateLine.backgroundColor = [UIColor lightGrayColor];
    return separateLine;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

- (NSArray *)dataSouce{
    
    if (_dataSouce == nil) {
        NSMutableArray * mArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i ++) {
            
            NSString * str = i % 2 ? [NSString stringWithFormat:@"地址0- %d",i] : [NSString stringWithFormat:@"地0-%d",i] ;
            [mArray addObject:str];
        }
        _dataSouce = mArray;
    }
    return _dataSouce;
}

- (NSArray *)dataSouce1{
    
    if (_dataSouce1 == nil) {
        NSMutableArray * mArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i ++) {
            
            NSString * str = i % 2 ? [NSString stringWithFormat:@"地址1- %d",i] : [NSString stringWithFormat:@"地1-%d",i] ;
            [mArray addObject:str];
        }
        _dataSouce1 = mArray;
    }
    return _dataSouce1;
}

- (NSArray *)dataSouce2{
    
    if (_dataSouce2 == nil) {
        NSMutableArray * mArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i ++) {
            
            NSString * str = i % 2 ? [NSString stringWithFormat:@"地址2- %d",i] : [NSString stringWithFormat:@"地2-%d",i] ;
            [mArray addObject:str];
        }
        _dataSouce2 = mArray;
    }
    return _dataSouce2;
}
@end