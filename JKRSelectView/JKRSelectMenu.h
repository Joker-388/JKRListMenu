//
//  JKRSelectMenu.h
//  JKRSelectView
//
//  Created by Lucky on 2017/5/11.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKRBaseSelectedView.h"

@interface JKRSelectMenu : UIView

+ (void)showWithSourceView:(JKRBaseSelectedView *)sourceView selectedBlock:(void(^)(NSUInteger index))selectedBlock;
+ (instancetype)selectMenuWithSourceView:(JKRBaseSelectedView *)sourceView;

@end
