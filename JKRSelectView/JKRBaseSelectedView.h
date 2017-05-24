//
//  JKRBaseSelectedView.h
//  JKRSelectView
//
//  Created by Lucky on 2017/5/10.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKRSelectedStore.h"
@class JKRBaseSelectedView;

@protocol JKRBaseSelectedViewDelegate <NSObject>

@required
- (void)baseSelectedView:(JKRBaseSelectedView *)selectedView didSelected:(NSUInteger)index;

@end

@interface JKRBaseSelectedView : UIView

/// 菜单项选中的index
@property (nonatomic, assign) NSUInteger selectedIndex;
/// 菜单项的层级
@property (nonatomic, assign) JKRSelectedType selectedType;
/// 菜单项的顶级index
@property (nonatomic, assign) JKRGameType gameType;
/// 当前菜单项是否可以点击
@property (nonatomic, assign) BOOL enable;
/// 当前菜单项的上一级菜单项
@property (nonatomic, strong) JKRBaseSelectedView *pre;
/// 菜单选择回调代理
@property (nonatomic, weak) id<JKRBaseSelectedViewDelegate> delegate;

@end
