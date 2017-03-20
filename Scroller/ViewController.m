//
//  ViewController.m
//  Scroller
//
//  Created by 徐可 on 2017/3/7.
//  Copyright © 2017年 Richers. All rights reserved.
//

#import "ViewController.h"
#import "LinkScrollerView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * contetArray = [[NSMutableArray alloc] init];
    
    LinkScrollerView * sc = [[LinkScrollerView alloc] initWithFrame:self.view.frame];
    sc.titleArray = [[NSMutableArray alloc] initWithObjects:@"测试1测试1测试1",@"测试2",@"测试3测试3",@"测试4测试4",@"测试5", nil];
    
    sc.minCount = 4; // 标题栏当前页面最少几个标签
    
    sc.selectedColor = [UIColor greenColor]; // 标题栏选中标题颜色
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [contetArray addObject:view];
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    [contetArray addObject:view];

    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    [contetArray addObject:view];

    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    [contetArray addObject:view];
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [contetArray addObject:view];
    sc.contentViewArray = contetArray;
    
    [sc loadContent];

    [self.view addSubview:sc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
