//
//  LinkScrollerView.h
//  Scroller
//
//  Created by 徐可 on 2017/3/16.
//  Copyright © 2017年 Richers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkScrollerView : UIView

// 抬头标题内容
@property (nonatomic, strong) NSMutableArray * titleArray;

// 内容视图数组
@property (nonatomic, strong) NSMutableArray * contentViewArray;

// 抬头标签少于几个的时候平均显示
@property (nonatomic, assign) NSInteger minCount;

-(void)loadContent;

@end
