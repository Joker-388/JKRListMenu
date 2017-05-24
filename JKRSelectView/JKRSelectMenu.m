//
//  JKRSelectMenu.m
//  JKRSelectView
//
//  Created by Lucky on 2017/5/11.  
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRSelectMenu.h"

typedef void(^selectedBlock)(NSUInteger index);

@interface JKRSelectMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) selectedBlock selectedBlock;
@property (nonatomic, assign) BOOL isShowing;

@end

@implementation JKRSelectMenu {
    CGFloat _cellHeight;
}

static NSString *const CELLID = @"JKR_SELECCT_MENU_CELL";

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isShowing) return self;
    return [super hitTest:point withEvent:event];
}

+ (void)showWithSourceView:(JKRBaseSelectedView *)sourceView selectedBlock:(void (^)(NSUInteger))selectedBlock{
    if (![[JKRSelectedStore sharedStore] selectItemsWithType:sourceView.selectedType gameType:sourceView.gameType]) return;
    JKRSelectMenu *menu = [JKRSelectMenu selectMenuWithSourceView:sourceView];
    menu.selectedBlock = selectedBlock;
    [menu showWithSourceView:sourceView];
}

+ (instancetype)selectMenuWithSourceView:(JKRBaseSelectedView *)sourceView {
    static JKRSelectMenu *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKRSelectMenu alloc] init];
        instance.backgroundColor = [UIColor whiteColor];
        instance.layer.masksToBounds = YES;
    });
    [instance _configWithSourceView:sourceView];
    return instance;
}

- (void)showWithSourceView:(JKRBaseSelectedView *)sourceView {
    CGFloat height = self.height;
    self.height = 0;
    self.isShowing = YES;
    [sourceView.jkr_viewController.view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.height = height;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isShowing = NO;
        });
    }];
}

- (void)_configWithSourceView:(JKRBaseSelectedView *)sourceView {
    self.items = [[JKRSelectedStore sharedStore] selectItemsWithType:sourceView.selectedType gameType:sourceView.gameType];
    [self _setFrameWithSourceView:sourceView];
    [self _setChildView];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)_setFrameWithSourceView:(JKRBaseSelectedView *)sourceView {
    CGFloat itemH = sourceView.height;
    CGFloat W = sourceView.width - 42;
    CGFloat H;
    CGFloat X;
    CGFloat Y;
    if (self.items.count >= 6) {
        H = itemH * 6;
    } else {
        H = self.items.count * itemH;
    }
    CGRect rect = [sourceView convertRect:sourceView.bounds toView:[UIApplication sharedApplication].keyWindow];
    Y = (sourceView.height - H) * 0.5 + rect.origin.y;
    X = sourceView.x;
    self.frame = CGRectMake(X, Y, W, H);
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
    _cellHeight = itemH;
}

- (void)_setChildView {
    [self.tableView reloadData];
    self.tableView.frame = self.bounds;
    [self addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowing) return;
    if(self.selectedBlock) self.selectedBlock(indexPath.row);
    [self hide];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isShowing) return;
    if(self.selectedBlock) self.selectedBlock(999);
    [self hide];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    }
    return _tableView;
}

@end
