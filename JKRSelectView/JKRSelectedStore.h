//
//  JKRSelectedStore.h
//  JKRSelectView
//
//  Created by Lucky on 2017/5/10.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JKRSelectedType) {
    JKRSelectedTypeGame = 0,   ///< 游戏
    JKRSelectedTypeArea,       ///< 区
    JKRSelectedTypeGrade,      ///< 段位
    JKRSelectedTypeClass       ///< 模式
};

typedef NS_ENUM(NSUInteger, JKRGameType) {
    JKRGameTypeNone = 0,
    JKRGameTypeWZRY,
    JKRGameTypeLOL,
};

@interface JKRSelectedStore : NSObject

+ (instancetype)sharedStore;
- (NSArray<NSString *> *)selectItemsWithType:(JKRSelectedType)type gameType:(JKRGameType)gameType;


@end
