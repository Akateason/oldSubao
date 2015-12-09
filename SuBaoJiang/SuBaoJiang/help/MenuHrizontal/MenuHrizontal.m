//
//  MenuHrizontal.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MenuHrizontal.h"
#import "ColorsHeader.h"
#import "UIImage+AddFunction.h"



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#define BUTTONITEMWIDTH   70

@implementation MenuHrizontal

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        if (mButtonArray == nil)
        {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil)
        {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator  = NO ;
            mScrollView.showsVerticalScrollIndicator    = NO ;
//            mScrollView.
        }
        if (_mItemInfoArray == nil)
        {
            _mItemInfoArray = [[NSMutableArray alloc] init];
        }
        [_mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor] ;
        
        if (mButtonArray == nil)
        {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil)
        {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (_mItemInfoArray == nil)
        {
            _mItemInfoArray = [[NSMutableArray alloc] init];
        }
        [_mItemInfoArray removeAllObjects];

    }
    return self;
}

- (void)setMItemInfoArray:(NSMutableArray *)mItemInfoArray
{
//    _mItemInfoArray = mItemInfoArray ;
    
    [self createMenuItems:mItemInfoArray];
}

+ (float)getWidthWithTitle:(NSString *)title
{
    return [title length] * 13 + 30 ;
}

- (float)getTotalWidthWithIndex:(int)index
{
    float totalWid = 0.0f ;
    
    for (int i = 0; i < _mItemInfoArray.count; i++)
    {
        NSString *title = _mItemInfoArray[i] ;
        totalWid += [[MenuHrizontal class] getWidthWithTitle:title] ;
        if (index == i) break ;
    }
    
    return totalWid ;
}

- (void)createMenuItems:(NSArray *)aItemsArray
{
    for (UIView *subs in [mScrollView subviews])
    {
        [subs removeFromSuperview] ;
    }
    [mButtonArray removeAllObjects] ;
    [_mItemInfoArray removeAllObjects] ;
    
    float menuWidth = 0.0;
    for (int i = 0; i < aItemsArray.count; i++)
    {
        NSString  *vTitleStr = aItemsArray[i]  ;
        
        float vButtonWidth = [[MenuHrizontal class] getWidthWithTitle:vTitleStr] ;
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageBack =[UIImage imageNamed:@"btBase"] ;
        
        [vButton setBackgroundImage:nil         forState:UIControlStateNormal]  ;
        [vButton setBackgroundImage:imageBack   forState:UIControlStateSelected];
        
        [vButton setTitle:vTitleStr             forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor darkGrayColor]
                      forState:UIControlStateNormal];
        [vButton setTitleColor:COLOR_MAIN
                      forState:UIControlStateSelected];
        [vButton setFont:[UIFont systemFontOfSize:12.0f]] ;
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)] ;
        
        [mScrollView addSubview:vButton] ;
        [mButtonArray addObject:vButton] ;
        
        menuWidth += vButtonWidth ;
        
        [_mItemInfoArray addObject:vTitleStr] ;
    }
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}

#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
- (void)changeButtonsToNormalState
{
    for (UIButton *vButton in mButtonArray)
    {
        vButton.selected = NO;
    }
}

#pragma mark 模拟选中第几个button
- (void)clickButtonAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

#pragma mark 移动button到可视的区域
- (void)moveScrolViewWithIndex:(NSInteger)aIndex
{
//    NSLog(@"_mItemInfoArray : %@", _mItemInfoArray) ;
//    NSLog(@"mTotalWidth : %lf", mTotalWidth) ;
    if (_mItemInfoArray.count < aIndex) return ;
    
    //宽度小于320肯定不需要移动
    if (mTotalWidth <= 320) return ;
    
//    NSString *title = [_mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [self getTotalWidthWithIndex:(int)aIndex] ;
    
    if (vButtonOrigin >= 300)
    {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width)
        {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0)
        {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
//    NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width) ;
    }
    else
    {
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
        return;
    }
}

#pragma mark - 点击事件
- (void)menuButtonClicked:(UIButton *)aButton
{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)])
    {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}


#pragma mark 内存相关
- (void)dealloc
{
    [mButtonArray removeAllObjects],mButtonArray = nil;
//    [super dealloc];
}


@end
