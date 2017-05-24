//
//  JKRBaseSelectedView.m
//  JKRSelectView
//
//  Created by Lucky on 2017/5/10.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRBaseSelectedView.h"
#import "JKRSelectMenu.h"
#import "NSObject+JKR_Observer.h"

@interface JKRBaseSelectedView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JKRBaseSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.enable) return;
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor whiteColor];
    if (!self.enable) return;
    [self _onSelected];
    @weakify(self);
    [JKRSelectMenu showWithSourceView:self selectedBlock:^(NSUInteger index) {
        @strongify(self);
        if (index != 999) self.selectedIndex = index;
        [self _endSelected];
    }];
}

- (void)_onSelected {
    self.imageView.image = [UIImage jkr_imageWithColor:JKRColorHex(000000) size:CGSizeMake(10, 10)];
}

- (void)_endSelected {
    self.imageView.image = self.selectedIndex ? [UIImage jkr_imageWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)] : [UIImage jkr_imageWithColor:JKRColorHex(535353) size:CGSizeMake(10, 10)];
}

- (void)_refreshSelected {
    self.selectedIndex = 0;
    [self _endSelected];
}

- (void)setPre:(JKRBaseSelectedView *)pre {
    _pre = pre;
    [_pre jkr_addObserver:self forKeyPath:@"selectedIndex" change:^(id newValue) {
        self.enable = self.pre.selectedIndex;
        [self _refreshSelected];
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.delegate baseSelectedView:self didSelected:selectedIndex];
    if (self.selectedType == JKRSelectedTypeGame) self.gameType = selectedIndex;
    if (selectedIndex == 0) {
        switch (self.selectedType) {
            case JKRSelectedTypeGame:
                self.titleLabel.text = @"选择游戏";
                break;
            case JKRSelectedTypeArea:
                self.titleLabel.text = @"选择游戏区";
                break;
            case JKRSelectedTypeGrade:
                self.titleLabel.text = @"选择段位";
                break;
            case JKRSelectedTypeClass:
                self.titleLabel.text = @"比赛模式";
                break;
            default:
                break;
        }
        return;
    }
    self.titleLabel.text = [[JKRSelectedStore sharedStore] selectItemsWithType:self.selectedType gameType:self.gameType][selectedIndex];
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.titleLabel.textColor = enable ? JKRColorHex(000000) : JKRColorHex(535353);
}

- (JKRGameType)gameType {
    if (self.selectedType != JKRSelectedTypeGame) {
        return [self.pre gameType];
    }
    return _gameType;
}

- (void)setSelectedType:(JKRSelectedType)selectedType {
    _selectedType = selectedType;
    if (_selectedType == JKRSelectedTypeGame) self.enable = YES;
    switch (selectedType) {
        case JKRSelectedTypeGame:
            self.titleLabel.text = @"选择游戏";
            break;
        case JKRSelectedTypeArea:
            self.titleLabel.text = @"选择游戏区";
            break;
        case JKRSelectedTypeGrade:
            self.titleLabel.text = @"选择段位";
            break;
        case JKRSelectedTypeClass:
            self.titleLabel.text = @"比赛模式";
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 0.5);
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = self.bounds;
        _titleLabel.textColor = JKRColorHex(535353);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(self.width - 27, (self.height - 20) / 2, 20, 20);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = [UIImage jkr_imageWithColor:JKRColorHex(535353) size:CGSizeMake(10, 10)];
    }
    return _imageView;
}

@end
