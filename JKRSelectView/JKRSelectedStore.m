//
//  JKRSelectedStore.m
//  JKRSelectView
//
//  Created by Lucky on 2017/5/10.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRSelectedStore.h"

@implementation JKRSelectedStore

+ (instancetype)sharedStore {
    static JKRSelectedStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKRSelectedStore alloc] init];
    });
    return instance;
}

- (NSArray<NSString *> *)selectItemsWithType:(JKRSelectedType)type gameType:(JKRGameType)gameType {
    switch (type) {
        case JKRSelectedTypeGame:
            return @[@"选择游戏", @"王者荣耀", @"英雄联盟"];
        default:
        {
            switch (gameType) {
                case JKRGameTypeLOL:
                    return [self _selectLOLItemsWithType:type];
                case JKRGameTypeWZRY:
                    return [self _selectWZRYItemsWithType:type];
                default:
                    return nil;
            }
        }
    }
}

- (NSArray<NSString *> *)_selectWZRYItemsWithType:(JKRSelectedType)type {
    switch (type) {
        case JKRSelectedTypeArea:
            return @[@"选择游戏区", @"微信大区", @"手Q大区"];
        case JKRSelectedTypeGrade:
            return @[@"选择段位", @"荣耀王者", @"最强王者", @"永恒钻石", @"尊贵铂金", @"荣耀黄金", @"秩序白银", @"倔强青铜"];
        case JKRSelectedTypeClass:
            return @[@"比赛模式", @"排位赛", @"其他模式"];
        default:
            return nil;
    }
}

- (NSArray<NSString *> *)_selectLOLItemsWithType:(JKRSelectedType)type {
    switch (type) {
        case JKRSelectedTypeArea:
            return @[@"选择游戏区", @"艾欧尼亚", @"祖安", @"诺克萨斯", @"班德尔城", @"皮尔特沃夫", @"战争学院", @"巨神峰", @"雷瑟守备", @"裁决之地", @"黑色玫瑰", @"暗影岛", @"钢铁烈阳", @"水晶之痕", @"均衡教派", @"影流", @"守望之海", @"征服之海", @"卡拉曼达", @"皮城警卫", @"比尔吉沃特", @"德玛西亚", @"弗雷尔卓德", @"无畏先锋", @"恕瑞玛", @"扭曲丛林", @"巨龙之巢", @"教育网专区"];
        case JKRSelectedTypeGrade:
            return @[@"选择段位", @"超凡大师", @"璀璨钻石1", @"璀璨钻石2", @"璀璨钻石3",@"璀璨钻石4", @"璀璨钻石5", @"华贵铂金", @"荣耀黄金", @"不屈白银", @"英勇黄铜"];
        case JKRSelectedTypeClass:
            return @[@"比赛模式", @"排位赛", @"其他模式"];
        default:
            return nil;
    }
}

@end
