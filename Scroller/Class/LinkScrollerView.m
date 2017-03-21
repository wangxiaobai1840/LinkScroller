//
//  LinkScrollerView.m
//  Scroller
//
//  Created by 徐可 on 2017/3/16.
//  Copyright © 2017年 Richers. All rights reserved.
//

#import "LinkScrollerView.h"

#define WIDTH self.frame.size.width

@interface LinkScrollerView()<UIScrollViewDelegate>
{
    
    CGFloat _oldContentOffSetX;
    UIImageView * _selectedImage; // 选中标题时底部图片
    NSInteger _titleSelectedIndex;
    UIScrollView * _titleScrollerView;
    UIScrollView * _contentScrollerView;
    
    
}
@end

@implementation LinkScrollerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _titleSelectedIndex = 100;
    _titleScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    _titleScrollerView.tag = 1000;
    _titleScrollerView.delegate = self;
    _titleScrollerView.showsVerticalScrollIndicator = NO;
    _titleScrollerView.showsHorizontalScrollIndicator = NO;

    [self addSubview:_titleScrollerView];
    
    _selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedImage"]];
    _selectedImage.frame = CGRectMake(0, CGRectGetHeight(_titleScrollerView.frame)-3, 100,3);
    [_titleScrollerView addSubview:_selectedImage];
    
    
    _contentScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScrollerView.frame), self.frame.size.width, self.frame.size.height)];
    _contentScrollerView.tag = 2000;
    _contentScrollerView.delegate = self;
    [self addSubview:_contentScrollerView];
//    [self setTitleContent];
}

- (void)loadContent{
    [self setTitleContent];
    [self setContentView];
}


#pragma mark 设置顶部标题行

- (void)setTitleContent{
    
    CGFloat width , x=0;
    if (_titleArray.count <= _minCount) {
        width =  self.frame.size.width / _titleArray.count;
        for (NSInteger i = 0;  i< _titleArray.count ; i++) {
            UIButton  * button = [self createButtonX:x width:width title:[_titleArray objectAtIndex:i] tag:100 + i];
            if (i == 0) {
                button.selected = YES;
                [self changeImageViewX:0 width:width];
                
            }else{
                button.selected = NO;
            }
            x = CGRectGetMaxX(button.frame);
        }
    }else{
        for (NSInteger i = 0;  i< _titleArray.count ; i++) {
            width = [[_titleArray objectAtIndex:i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size.width + 20 ;
            UIButton  * button = [self createButtonX:x width:width  title:[_titleArray objectAtIndex:i] tag:100+ i];
            if (i == 0) {
                button.selected = YES;
                [self changeImageViewX:0 width:width];
            }else{
                button.selected = NO;
            }
            x = CGRectGetMaxX(button.frame);
        }
    }
    _titleScrollerView.contentSize = CGSizeMake(x, 40);
}

#pragma  mark 改变标题栏下方图片位置

- (void)changeImageViewX:(CGFloat)x width:(CGFloat)width{
[UIView animateWithDuration:0.2 animations:^{
    CGRect frame = _selectedImage.frame;
    frame.origin.x = x;
    frame.size.width = width;
    _selectedImage.frame = frame;
}];
}

#pragma mark 设置页面内容

- (void)setContentView{
    CGFloat width = 0.0;
    for (NSInteger i = 0; i< _contentViewArray.count; i++) {
        UIView *  content  = (UIView *)[_contentViewArray objectAtIndex:i];
        content.frame = CGRectMake(WIDTH * i, 0, WIDTH, _contentScrollerView.frame.size.height);
        width = CGRectGetMaxX(content.frame);
        [_contentScrollerView addSubview:content];
    }
    _contentScrollerView.contentSize = CGSizeMake(width, _contentScrollerView.frame.size.height);
}


- (UIButton *)createButtonX:(CGFloat)x width:(CGFloat)width title:(NSString *)title tag:(NSInteger)tag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, 0 , width, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:_selectedColor forState:UIControlStateSelected];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = tag;
    [button addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_titleScrollerView addSubview:button];
    return button;
}

#pragma mark 点击顶部标题栏

- (void)titleButtonSelected:(UIButton *)sender
{
    if (sender.tag ==  _titleSelectedIndex) {
        return;
    }
    [self unselectedButtonIndex];
    sender.selected = YES;
    _titleSelectedIndex = sender.tag;
    [self contentScrollerToIndexSelected];
    [self changeImageViewX:sender.frame.origin.x width:sender.frame.size.width];

}

- (void)unselectedButtonIndex{
    UIButton * button = (UIButton *)[_titleScrollerView viewWithTag:_titleSelectedIndex];
    button.selected = NO;
}

- (void)contentScrollerToIndexSelected{
    
    [_contentScrollerView scrollRectToVisible:CGRectMake((_titleSelectedIndex - 100) * WIDTH, _contentScrollerView.frame.origin.y, WIDTH, _contentScrollerView.frame.size.height) animated:YES];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
        if (scrollView == _contentScrollerView) {
            
        CGPoint point = scrollView.contentOffset;
        NSInteger page ;

        if (point.x > _oldContentOffSetX) {
            page = floor(point.x / WIDTH) + 1;
        }else{
            page = floor(point.x / WIDTH);
        }
            [_contentScrollerView scrollRectToVisible:CGRectMake(page * WIDTH, _contentScrollerView.frame.origin.y, WIDTH, _contentScrollerView.frame.size.height) animated:YES];
            if (page >= 0 && page < _contentViewArray.count) {
                [self setTitleSelected:page];
            }
        }
    
}

- (void)setTitleSelected:(NSInteger)index{
    [self unselectedButtonIndex];
    UIButton * button = (UIButton *)[_titleScrollerView viewWithTag:index + 100];
    button.selected = YES;
    _titleSelectedIndex = button.tag;
    [self changeImageViewX:button.frame.origin.x width:button.frame.size.width];
    if (CGRectGetMaxX(button.frame) > WIDTH ) {
        
        [_titleScrollerView scrollRectToVisible:CGRectMake(CGRectGetMaxX(button.frame), 0 , WIDTH, _titleScrollerView.frame.size.height) animated:YES];
        
    }else if (CGRectGetMinX(button.frame) < _titleScrollerView.contentOffset.x ){

        [_titleScrollerView scrollRectToVisible:CGRectMake(CGRectGetMinX(button.frame), 0 , WIDTH, _titleScrollerView.frame.size.height) animated:YES];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _contentScrollerView) {
        _oldContentOffSetX = scrollView.contentOffset.x;
    }
}
@end
