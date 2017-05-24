//
//  ViewController.m
//  JKRSelectView
//
//  Created by Lucky on 2017/5/24.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "ViewController.h"
#import "JKRBaseSelectedView.h"

@interface ViewController ()<JKRBaseSelectedViewDelegate>

@property (nonatomic, assign) NSUInteger gameIndex;
@property (nonatomic, assign) NSUInteger areaIndex;
@property (nonatomic, assign) NSUInteger gradeIndex;
@property (nonatomic, strong) UILabel *resultGameLabel;
@property (nonatomic, strong) UILabel *resultAreaLabel;
@property (nonatomic, strong) UILabel *resultGradeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSelectViews];
    [self addLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.resultGameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.view.subviews[self.view.subviews.count - 4].frame) + 100, self.view.width - 20, 45);
    self.resultAreaLabel.frame = CGRectMake(10, CGRectGetMaxY(self.resultGameLabel.frame), self.view.width - 20, 45);
    self.resultGradeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.resultAreaLabel.frame), self.view.width - 20, 45);
}

#pragma mark - 添加菜单项
- (void)addSelectViews {
    // 计算每一个菜单项的frame
    CGFloat M = 10;
    CGFloat W = self.view.width - 30;
    CGFloat H = 44;
    CGFloat X = 15;
    CGFloat Y = 0;
    CGFloat TopMargin = 100;
    JKRBaseSelectedView *preView = nil;
    // 通过for循环添加菜单项
    for (NSUInteger i = 0; i < 3; i++) {
        Y = (M + H) * i + TopMargin;
        JKRBaseSelectedView *selectedView = [[JKRBaseSelectedView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        selectedView.delegate = self; // 设置菜单项的代理获取菜单选择回调
        selectedView.selectedType = i;
        if (preView) selectedView.pre = preView;
        [self.view addSubview:selectedView];
        preView = selectedView;
    }
}

- (void)addLabel {
    [self.view addSubview:self.resultGameLabel];
    [self.view addSubview:self.resultAreaLabel];
    [self.view addSubview:self.resultGradeLabel];
}

#pragma mark - 监听菜单点击
- (void)baseSelectedView:(JKRBaseSelectedView *)selectedView didSelected:(NSUInteger)index {
    switch (selectedView.selectedType) {
        case JKRSelectedTypeGame:         // 第一个菜单项改变
            self.gameIndex = index;
            [self refreshGameResult];
            break;
        case JKRSelectedTypeArea:         // 第二个菜单项改变
            self.areaIndex = index;
            [self refreshAreaResult];
            break;
        case JKRSelectedTypeGrade:        // 第三个菜单项改变
            self.gradeIndex = index;
            [self refreshGradeResult];
            break;
        default:
            break;
    }
}

#pragma mark - 刷新结果
- (void)refreshGameResult {
    NSString *game = [[JKRSelectedStore sharedStore] selectItemsWithType:JKRSelectedTypeGame gameType:0][self.gameIndex];
    NSString *result = [NSString stringWithFormat:@"游戏：%@", game];
    self.resultGameLabel.text = result;
}

- (void)refreshAreaResult {
    NSString *Arae = [[JKRSelectedStore sharedStore] selectItemsWithType:JKRSelectedTypeArea gameType:self.gameIndex][self.areaIndex];
    NSString *result = [NSString stringWithFormat:@"大区：%@", Arae];
    self.resultAreaLabel.text = result;
}

- (void)refreshGradeResult {
    NSString *Grade = [[JKRSelectedStore sharedStore] selectItemsWithType:JKRSelectedTypeGrade gameType:self.gameIndex][self.gradeIndex];
    NSString *result = [NSString stringWithFormat:@"段位：%@", Grade];
    self.resultGradeLabel.text = result;
}

#pragma mark - 懒加载
- (UILabel *)resultGameLabel {
    if (!_resultGameLabel) {
        _resultGameLabel = createResultLabel();
    }
    return _resultGameLabel;
}

- (UILabel *)resultAreaLabel {
    if (!_resultAreaLabel) {
        _resultAreaLabel = createResultLabel();
    }
    return _resultAreaLabel;
}

- (UILabel *)resultGradeLabel {
    if (!_resultGradeLabel) {
        _resultGradeLabel = createResultLabel();
    }
    return _resultGradeLabel;
}

static UILabel *createResultLabel() {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = JKRColorHex(000000);
    label.numberOfLines = 0;
    return label;
}



@end
